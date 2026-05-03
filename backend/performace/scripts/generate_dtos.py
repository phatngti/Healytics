#!/usr/bin/env python3
"""Generate Python DTO models from the performance OpenAPI document."""

from __future__ import annotations

import argparse
import json
import keyword
import re
from collections import OrderedDict, defaultdict
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any


SCRIPT_DIR = Path(__file__).resolve().parent
PERFORMACE_DIR = SCRIPT_DIR.parent
DEFAULT_INPUT = PERFORMACE_DIR / "api_docs/openapi.json"
DEFAULT_OUTPUT = PERFORMACE_DIR / "models"
SHARED_MODULE = "shared"

JSON_SCHEMA_SCALAR_TYPES = {
    "string": "str",
    "integer": "int",
    "number": "float",
    "boolean": "bool",
}


@dataclass(frozen=True)
class FieldSpec:
    python_name: str
    json_name: str
    annotation: str
    required: bool
    default_expr: str | None = None


@dataclass(frozen=True)
class DataclassSpec:
    name: str
    fields: list[FieldSpec]


@dataclass(frozen=True)
class EnumSpec:
    name: str
    values: list[Any]


@dataclass(frozen=True)
class AliasSpec:
    name: str
    annotation: str


@dataclass(frozen=True)
class InlineAliasSpec:
    name: str
    annotation: str
    controller: str
    method: str
    path: str
    status_code: str


@dataclass
class ModuleBucket:
    module_name: str
    enums: OrderedDict[str, EnumSpec] = field(default_factory=OrderedDict)
    dataclasses: OrderedDict[str, DataclassSpec] = field(default_factory=OrderedDict)
    aliases: OrderedDict[str, AliasSpec] = field(default_factory=OrderedDict)
    inline_aliases: OrderedDict[str, InlineAliasSpec] = field(default_factory=OrderedDict)

    def symbol_names(self) -> list[str]:
        return list(self.enums) + list(self.dataclasses) + list(self.aliases) + list(self.inline_aliases)


@dataclass(frozen=True)
class OutputPaths:
    package_dir: Path


@dataclass
class GeneratorState:
    openapi: dict[str, Any]
    components: dict[str, Any]
    controller_seeds: dict[str, set[str]] = field(default_factory=lambda: defaultdict(set))
    controller_reachable: dict[str, set[str]] = field(default_factory=dict)
    component_owners: dict[str, set[str]] = field(default_factory=dict)
    enum_specs: OrderedDict[str, EnumSpec] = field(default_factory=OrderedDict)
    dataclass_specs: OrderedDict[str, DataclassSpec] = field(default_factory=OrderedDict)
    alias_specs: OrderedDict[str, AliasSpec] = field(default_factory=OrderedDict)
    inline_alias_specs: OrderedDict[str, InlineAliasSpec] = field(default_factory=OrderedDict)
    module_buckets: OrderedDict[str, ModuleBucket] = field(default_factory=OrderedDict)
    symbol_module: dict[str, str] = field(default_factory=dict)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", default=str(DEFAULT_INPUT), help="Path to the OpenAPI JSON file.")
    parser.add_argument(
        "--output",
        default=str(DEFAULT_OUTPUT),
        help="Path to the generated models package.",
    )
    args = parser.parse_args()

    input_path = resolve_path(args.input, PERFORMACE_DIR)
    output_paths = OutputPaths(package_dir=resolve_output_dir(args.output))

    with input_path.open("r", encoding="utf-8") as handle:
        openapi = json.load(handle)

    state = GeneratorState(
        openapi=openapi,
        components=openapi.get("components", {}).get("schemas", {}),
    )

    collect_controller_seeds(state)
    collect_component_owners(state)
    build_specs(state)
    assign_specs_to_modules(state)
    write_outputs(state, output_paths)

    print(
        "Generated "
        f"{len(state.enum_specs)} enums, "
        f"{len(state.dataclass_specs)} dataclasses, "
        f"{len(state.alias_specs)} component aliases, and "
        f"{len(state.inline_alias_specs)} inline response aliases "
        f"to {output_paths.package_dir}"
    )


def resolve_path(raw_path: str, base_dir: Path) -> Path:
    path = Path(raw_path).expanduser()
    if path.is_absolute():
        return path

    cwd_path = (Path.cwd() / path).resolve()
    if cwd_path.exists():
        return cwd_path

    return (base_dir / path).resolve()


def resolve_output_dir(raw_output: str) -> Path:
    resolved = resolve_path(raw_output, PERFORMACE_DIR)
    if resolved.suffix == ".py":
        return resolved.parent
    return resolved


def collect_controller_seeds(state: GeneratorState) -> None:
    for path, methods in sorted(state.openapi.get("paths", {}).items()):
        for method, operation in sorted(methods.items()):
            controller = controller_name(operation.get("operationId"), method, path)
            request_body = operation.get("requestBody") or {}
            for _, body in sorted((request_body.get("content") or {}).items()):
                schema = body.get("schema") or {}
                state.controller_seeds[controller].update(collect_refs(schema))

            for status_code, response in sorted((operation.get("responses") or {}).items()):
                for _, body in sorted((response.get("content") or {}).items()):
                    schema = body.get("schema") or {}
                    state.controller_seeds[controller].update(collect_refs(schema))

                    if schema.get("type") == "array":
                        operation_id = operation.get("operationId") or synthesize_operation_id(method, path)
                        alias_name = synthetic_response_alias_name(operation_id)
                        state.inline_alias_specs[alias_name] = InlineAliasSpec(
                            name=alias_name,
                            annotation=annotation_for_schema(state, schema),
                            controller=controller,
                            method=method.upper(),
                            path=path,
                            status_code=status_code,
                        )


def collect_component_owners(state: GeneratorState) -> None:
    component_owners: dict[str, set[str]] = defaultdict(set)

    for controller, seeds in sorted(state.controller_seeds.items()):
        reachable = traverse_components(state.components, seeds)
        state.controller_reachable[controller] = reachable
        for component in reachable:
            component_owners[component].add(controller)

    state.component_owners = dict(component_owners)


def traverse_components(components: dict[str, Any], seeds: set[str]) -> set[str]:
    reachable: set[str] = set()
    stack = list(sorted(seeds))
    while stack:
        name = stack.pop()
        if name in reachable or name not in components:
            continue
        reachable.add(name)
        stack.extend(sorted(collect_refs(components[name]) - reachable))
    return reachable


def build_specs(state: GeneratorState) -> None:
    for name in sorted(state.component_owners):
        schema = state.components[name]

        if "enum" in schema:
            state.enum_specs[name] = EnumSpec(name=name, values=list(schema["enum"]))
            continue

        if is_object_dataclass(schema):
            state.dataclass_specs[name] = DataclassSpec(name=name, fields=build_field_specs(state, schema))
            continue

        state.alias_specs[name] = AliasSpec(name=name, annotation=annotation_for_schema(state, schema))


def build_field_specs(state: GeneratorState, schema: dict[str, Any]) -> list[FieldSpec]:
    required = set(schema.get("required", []))
    properties = schema.get("properties", {})

    required_fields: list[FieldSpec] = []
    optional_fields: list[FieldSpec] = []

    for json_name, property_schema in properties.items():
        python_name = python_identifier(json_name)
        annotation = annotation_for_schema(state, property_schema)
        is_required = json_name in required
        default_expr: str | None = None

        if not is_required:
            if "| None" not in annotation:
                annotation = f"{annotation} | None"
            if property_schema.get("default") == []:
                default_expr = "default_factory=list"
            elif property_schema.get("default") == {}:
                default_expr = "default_factory=dict"
            else:
                default_expr = "default=None"

        field_spec = FieldSpec(
            python_name=python_name,
            json_name=json_name,
            annotation=annotation,
            required=is_required,
            default_expr=default_expr,
        )

        if is_required:
            required_fields.append(field_spec)
        else:
            optional_fields.append(field_spec)

    return required_fields + optional_fields


def assign_specs_to_modules(state: GeneratorState) -> None:
    module_buckets: OrderedDict[str, ModuleBucket] = OrderedDict()
    module_buckets[SHARED_MODULE] = ModuleBucket(module_name=SHARED_MODULE)

    for controller in sorted(state.controller_seeds):
        module_buckets[module_name_for_controller(controller)] = ModuleBucket(
            module_name=module_name_for_controller(controller)
        )

    for name, enum_spec in state.enum_specs.items():
        module = owner_module_for_component(state.component_owners[name])
        module_buckets[module].enums[name] = enum_spec
        state.symbol_module[name] = module

    for name, dataclass_spec in state.dataclass_specs.items():
        module = owner_module_for_component(state.component_owners[name])
        module_buckets[module].dataclasses[name] = dataclass_spec
        state.symbol_module[name] = module

    for name, alias_spec in state.alias_specs.items():
        module = owner_module_for_component(state.component_owners[name])
        module_buckets[module].aliases[name] = alias_spec
        state.symbol_module[name] = module

    for name, inline_alias_spec in state.inline_alias_specs.items():
        module = module_name_for_controller(inline_alias_spec.controller)
        module_buckets[module].inline_aliases[name] = inline_alias_spec
        state.symbol_module[name] = module

    state.module_buckets = OrderedDict(
        (name, bucket) for name, bucket in module_buckets.items() if bucket.symbol_names() or name == SHARED_MODULE
    )


def owner_module_for_component(owners: set[str]) -> str:
    if len(owners) != 1:
        return SHARED_MODULE
    return module_name_for_controller(next(iter(owners)))


def is_object_dataclass(schema: dict[str, Any]) -> bool:
    return schema.get("type") == "object" and bool(schema.get("properties"))


def annotation_for_schema(state: GeneratorState, schema: dict[str, Any]) -> str:
    annotation = annotation_for_schema_inner(state, schema)
    if schema.get("nullable"):
        return f"{annotation} | None"
    return annotation


def annotation_for_schema_inner(state: GeneratorState, schema: dict[str, Any]) -> str:
    ref_name = ref_name_from_schema(schema)
    if ref_name:
        return ref_name

    all_of = schema.get("allOf")
    if all_of:
        if len(all_of) == 1:
            return annotation_for_schema(state, all_of[0])
        return "Any"

    if "enum" in schema:
        return "str"

    schema_type = schema.get("type")
    if schema_type in JSON_SCHEMA_SCALAR_TYPES:
        if schema_type == "string":
            schema_format = schema.get("format")
            if schema_format == "date-time":
                return "datetime"
            if schema_format == "uuid":
                return "str"
        return JSON_SCHEMA_SCALAR_TYPES[schema_type]

    if schema_type == "array":
        items = schema.get("items", {})
        return f"list[{annotation_for_schema(state, items)}]"

    if schema_type == "object":
        properties = schema.get("properties")
        if properties:
            return "dict[str, Any]"
        additional = schema.get("additionalProperties")
        if isinstance(additional, dict):
            return f"dict[str, {annotation_for_schema(state, additional)}]"
        return "dict[str, Any]"

    if schema.get("nullable"):
        return "Any"

    return "Any"


def collect_refs(node: Any) -> set[str]:
    refs: set[str] = set()

    def walk(value: Any) -> None:
        if isinstance(value, dict):
            ref_name = ref_name_from_schema(value)
            if ref_name:
                refs.add(ref_name)
            for child in value.values():
                walk(child)
        elif isinstance(value, list):
            for item in value:
                walk(item)

    walk(node)
    return refs


def ref_name_from_schema(schema: dict[str, Any]) -> str | None:
    ref = schema.get("$ref")
    if not ref:
        return None
    return ref.rsplit("/", 1)[-1]


def synthetic_response_alias_name(operation_id: str) -> str:
    base = pascal_case(operation_id)
    if not base.endswith("ResponseDto"):
        base = f"{base}ResponseDto"
    return base


def controller_name(operation_id: str | None, method: str, path: str) -> str:
    if operation_id:
        match = re.search(r"([A-Za-z0-9]+Controller)", operation_id)
        if match:
            return pascal_case(match.group(1))
        if "_" in operation_id:
            return pascal_case(operation_id.split("_", 1)[0])
        return pascal_case(operation_id)
    return f"{pascal_case(synthesize_operation_id(method, path))}Controller"


def module_name_for_controller(controller: str) -> str:
    return snake_case(controller)


def synthesize_operation_id(method: str, path: str) -> str:
    clean_path = path.strip("/") or "root"
    segments = [segment.strip("{}") for segment in clean_path.split("/") if segment]
    return "_".join([method.lower(), *segments])


def python_identifier(name: str) -> str:
    candidate = re.sub(r"\W", "_", name)
    if not candidate:
        candidate = "field_"
    if candidate[0].isdigit():
        candidate = f"field_{candidate}"
    if keyword.iskeyword(candidate):
        candidate = f"{candidate}_"
    return candidate


def pascal_case(value: str) -> str:
    parts = re.split(r"[^A-Za-z0-9]+", value)
    words: list[str] = []
    for part in parts:
        if not part:
            continue
        split_part = re.findall(r"[A-Z]+(?=[A-Z][a-z]|\d|$)|[A-Z]?[a-z]+|\d+", part)
        words.extend(split_part or [part])
    return "".join(word[:1].upper() + word[1:] for word in words)


def snake_case(value: str) -> str:
    normalized = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", value)
    normalized = re.sub(r"([A-Z]+)([A-Z][a-z])", r"\1_\2", normalized)
    return normalized.replace("-", "_").lower()


def write_outputs(state: GeneratorState, output_paths: OutputPaths) -> None:
    package_dir = output_paths.package_dir
    package_dir.mkdir(parents=True, exist_ok=True)
    cleanup_generated_modules(package_dir)

    for module_name, bucket in state.module_buckets.items():
        module_path = package_dir / f"{module_name}.py"
        module_path.write_text(render_module(state, bucket), encoding="utf-8")

    (package_dir / "__init__.py").write_text(render_init_module(state), encoding="utf-8")


def cleanup_generated_modules(package_dir: Path) -> None:
    for path in package_dir.glob("*.py"):
        if path.name == "base.py":
            continue
        try:
            first_line = path.read_text(encoding="utf-8").splitlines()[:1]
        except OSError:
            continue
        if first_line and "Generated" in first_line[0]:
            path.unlink()


def render_module(state: GeneratorState, bucket: ModuleBucket) -> str:
    lines = [
        f'"""Generated models for {bucket.module_name}. Do not edit manually."""',
        "",
        "from __future__ import annotations",
        "",
    ]

    referenced_symbols = collect_module_symbol_refs(state, bucket)
    external_refs = sorted(name for name in referenced_symbols if state.symbol_module.get(name) != bucket.module_name)
    if bucket.enums:
        lines.append("from enum import Enum")
    if symbol_uses_datetime(bucket):
        lines.append("from datetime import datetime")
    if bucket.aliases or bucket.inline_aliases:
        lines.append("from typing import Any, TypeAlias")
    elif module_uses_any(bucket):
        lines.append("from typing import Any")
    if bucket.dataclasses:
        lines.append("from dataclasses import dataclass")
        lines.append("from .base import DtoModel, dto_field")
    if external_refs:
        shared_refs = [name for name in external_refs if state.symbol_module[name] == SHARED_MODULE]
        if shared_refs:
            lines.append(f"from .{SHARED_MODULE} import {', '.join(shared_refs)}")
    lines.extend(["", ""])

    for enum_spec in bucket.enums.values():
        lines.extend(render_enum(enum_spec))

    for dataclass_spec in bucket.dataclasses.values():
        lines.extend(render_dataclass(dataclass_spec))

    for alias_spec in bucket.aliases.values():
        lines.extend(render_alias(alias_spec))

    for inline_alias in bucket.inline_aliases.values():
        lines.extend(render_inline_alias(inline_alias))

    lines.extend(render_all(bucket.symbol_names()))
    return "\n".join(lines)


def symbol_uses_datetime(bucket: ModuleBucket) -> bool:
    annotations = []
    for dataclass_spec in bucket.dataclasses.values():
        annotations.extend(field_spec.annotation for field_spec in dataclass_spec.fields)
    annotations.extend(alias_spec.annotation for alias_spec in bucket.aliases.values())
    annotations.extend(alias_spec.annotation for alias_spec in bucket.inline_aliases.values())
    return any("datetime" in annotation for annotation in annotations)


def module_uses_any(bucket: ModuleBucket) -> bool:
    annotations = []
    for dataclass_spec in bucket.dataclasses.values():
        annotations.extend(field_spec.annotation for field_spec in dataclass_spec.fields)
    annotations.extend(alias_spec.annotation for alias_spec in bucket.aliases.values())
    annotations.extend(alias_spec.annotation for alias_spec in bucket.inline_aliases.values())
    return any("Any" in annotation for annotation in annotations)


def collect_module_symbol_refs(state: GeneratorState, bucket: ModuleBucket) -> set[str]:
    all_symbols = set(state.symbol_module)
    refs: set[str] = set()

    for dataclass_spec in bucket.dataclasses.values():
        for field_spec in dataclass_spec.fields:
            refs.update(extract_symbol_refs(field_spec.annotation, all_symbols))
    for alias_spec in bucket.aliases.values():
        refs.update(extract_symbol_refs(alias_spec.annotation, all_symbols))
    for alias_spec in bucket.inline_aliases.values():
        refs.update(extract_symbol_refs(alias_spec.annotation, all_symbols))

    return refs - set(bucket.symbol_names())


def extract_symbol_refs(annotation: str, all_symbols: set[str]) -> set[str]:
    return {token for token in re.findall(r"\b[A-Za-z_][A-Za-z0-9_]*\b", annotation) if token in all_symbols}


def render_init_module(state: GeneratorState) -> str:
    lines = [
        '"""Generated package surface for OpenAPI DTO models. Do not edit manually."""',
        "",
        "from __future__ import annotations",
        "",
    ]

    exported_lists: list[str] = []
    for module_name in state.module_buckets:
        lines.append(f"from .{module_name} import *")
        lines.append(f"from .{module_name} import __all__ as _{module_name}_all")
        exported_lists.append(f"*_{module_name}_all")

    lines.extend(
        [
            "",
            "__all__ = [",
            *[f"    {name}," for name in exported_lists],
            "]",
            "",
        ]
    )
    return "\n".join(lines)


def render_all(names: list[str]) -> list[str]:
    return [
        "__all__ = [",
        *[f'    "{name}",' for name in names],
        "]",
        "",
    ]


def render_enum(enum_spec: EnumSpec) -> list[str]:
    lines = [f"class {enum_spec.name}(str, Enum):"]
    for value in enum_spec.values:
        member_name = python_identifier(str(value)).upper()
        lines.append(f"    {member_name} = {value!r}")
    lines.extend(["", ""])
    return lines


def render_dataclass(dataclass_spec: DataclassSpec) -> list[str]:
    lines = ["@dataclass(slots=True)", f"class {dataclass_spec.name}(DtoModel):"]
    if not dataclass_spec.fields:
        lines.append("    pass")
        lines.extend(["", ""])
        return lines

    for field_spec in dataclass_spec.fields:
        lines.append(render_field(field_spec))

    lines.extend(["", ""])
    return lines


def render_field(field_spec: FieldSpec) -> str:
    needs_alias = field_spec.python_name != field_spec.json_name
    if field_spec.default_expr is None and not needs_alias:
        return f"    {field_spec.python_name}: {field_spec.annotation}"
    if field_spec.default_expr is None and needs_alias:
        return (
            f"    {field_spec.python_name}: {field_spec.annotation} = "
            f"dto_field(alias={field_spec.json_name!r})"
        )

    if needs_alias:
        return (
            f"    {field_spec.python_name}: {field_spec.annotation} = "
            f"dto_field({field_spec.default_expr}, alias={field_spec.json_name!r})"
        )

    if field_spec.default_expr == "default=None":
        return f"    {field_spec.python_name}: {field_spec.annotation} = None"
    return f"    {field_spec.python_name}: {field_spec.annotation} = dto_field({field_spec.default_expr})"


def render_alias(alias_spec: AliasSpec) -> list[str]:
    return [f"{alias_spec.name}: TypeAlias = {alias_spec.annotation}", "", ""]


def render_inline_alias(alias_spec: InlineAliasSpec) -> list[str]:
    return [
        (
            f"{alias_spec.name}: TypeAlias = {alias_spec.annotation}  "
            f"# {alias_spec.method} {alias_spec.path} [{alias_spec.status_code}]"
        ),
        "",
        "",
    ]


if __name__ == "__main__":
    main()
