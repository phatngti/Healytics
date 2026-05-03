"""Shared runtime helpers for generated OpenAPI DTO models."""

from __future__ import annotations

import types
from dataclasses import MISSING, dataclass, field, fields, is_dataclass
from datetime import datetime
from enum import Enum
from typing import Any, Callable, TypeVar, Union, get_args, get_origin, get_type_hints

TDto = TypeVar("TDto", bound="DtoModel")


def dto_field(
    *,
    alias: str | None = None,
    default: Any = MISSING,
    default_factory: Callable[[], Any] | Any = MISSING,
):
    metadata = {}
    if alias is not None:
        metadata["alias"] = alias

    kwargs: dict[str, Any] = {"metadata": metadata}
    if default is not MISSING:
        kwargs["default"] = default
    if default_factory is not MISSING:
        kwargs["default_factory"] = default_factory
    return field(**kwargs)


def _unwrap_union(annotation: Any) -> list[Any]:
    origin = get_origin(annotation)
    if origin in (types.UnionType, Union):
        return list(get_args(annotation))
    return []


def _coerce_datetime(value: Any) -> datetime:
    if isinstance(value, datetime):
        return value
    if isinstance(value, str):
        return datetime.fromisoformat(value.replace("Z", "+00:00"))
    raise TypeError(f"Cannot coerce {value!r} to datetime")


def _coerce_value(value: Any, annotation: Any) -> Any:
    if value is None:
        return None

    union_args = _unwrap_union(annotation)
    if union_args:
        non_none_args = [arg for arg in union_args if arg is not type(None)]
        if not non_none_args:
            return None
        for option in non_none_args:
            try:
                return _coerce_value(value, option)
            except Exception:
                continue
        return value

    origin = get_origin(annotation)
    if origin is list:
        args = get_args(annotation)
        item_type = args[0] if args else Any
        return [_coerce_value(item, item_type) for item in value]
    if origin is dict:
        args = get_args(annotation)
        value_type = args[1] if len(args) > 1 else Any
        return {key: _coerce_value(item, value_type) for key, item in value.items()}

    if annotation is Any:
        return value
    if annotation is datetime:
        return _coerce_datetime(value)
    if isinstance(annotation, type) and issubclass(annotation, Enum):
        return annotation(value)
    if isinstance(annotation, type) and is_dataclass(annotation):
        if isinstance(value, annotation):
            return value
        return annotation.from_dict(value)
    return value


def _serialize_value(value: Any, annotation: Any) -> Any:
    if value is None:
        return None

    union_args = _unwrap_union(annotation)
    if union_args:
        non_none_args = [arg for arg in union_args if arg is not type(None)]
        if not non_none_args:
            return None
        for option in non_none_args:
            try:
                return _serialize_value(value, option)
            except Exception:
                continue
        return value

    origin = get_origin(annotation)
    if origin is list:
        args = get_args(annotation)
        item_type = args[0] if args else Any
        return [_serialize_value(item, item_type) for item in value]
    if origin is dict:
        args = get_args(annotation)
        value_type = args[1] if len(args) > 1 else Any
        return {key: _serialize_value(item, value_type) for key, item in value.items()}

    if annotation is Any:
        return value
    if annotation is datetime:
        return value.isoformat() if isinstance(value, datetime) else value
    if isinstance(value, Enum):
        return value.value
    if is_dataclass(value):
        return value.to_dict()
    return value


@dataclass(slots=True)
class DtoModel:
    @classmethod
    def from_dict(cls: type[TDto], data: dict[str, Any]) -> TDto:
        if isinstance(data, cls):
            return data
        if not isinstance(data, dict):
            raise TypeError(f"Expected dict for {cls.__name__}, got {type(data).__name__}")

        hints = get_type_hints(cls)
        kwargs: dict[str, Any] = {}
        for field_info in fields(cls):
            json_key = field_info.metadata.get("alias", field_info.name)
            if json_key not in data:
                continue
            kwargs[field_info.name] = _coerce_value(data[json_key], hints[field_info.name])
        return cls(**kwargs)

    def to_dict(self) -> dict[str, Any]:
        hints = get_type_hints(type(self))
        payload: dict[str, Any] = {}
        for field_info in fields(self):
            json_key = field_info.metadata.get("alias", field_info.name)
            value = getattr(self, field_info.name)
            payload[json_key] = _serialize_value(value, hints[field_info.name])
        return payload


__all__ = ["DtoModel", "dto_field"]
