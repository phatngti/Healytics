"""Generated models for mapbox_controller. Do not edit manually."""

from __future__ import annotations

from dataclasses import dataclass
from .base import DtoModel, dto_field


@dataclass(slots=True)
class ClientKeyResponseDto(DtoModel):
    apiKey: str


@dataclass(slots=True)
class DirectionsCoordinateDto(DtoModel):
    latitude: float
    longitude: float


@dataclass(slots=True)
class DirectionsResponseDto(DtoModel):
    route: list[DirectionsCoordinateDto]
    distanceText: str
    distanceValue: float
    durationText: str
    durationValue: float


@dataclass(slots=True)
class DistanceMatrixElementDto(DtoModel):
    distanceText: str
    distanceValue: float
    durationText: str
    durationValue: float
    status: str


@dataclass(slots=True)
class DistanceMatrixResponseDto(DtoModel):
    originAddresses: list[str]
    destinationAddresses: list[str]
    rows: list[DistanceMatrixRowDto]


@dataclass(slots=True)
class DistanceMatrixRowDto(DtoModel):
    elements: list[DistanceMatrixElementDto]


@dataclass(slots=True)
class GeocodeResponseDto(DtoModel):
    results: list[GeocodeResultDto]


@dataclass(slots=True)
class GeocodeResultDto(DtoModel):
    lat: float
    lng: float
    formattedAddress: str
    placeId: str | None = None


__all__ = [
    "ClientKeyResponseDto",
    "DirectionsCoordinateDto",
    "DirectionsResponseDto",
    "DistanceMatrixElementDto",
    "DistanceMatrixResponseDto",
    "DistanceMatrixRowDto",
    "GeocodeResponseDto",
    "GeocodeResultDto",
]
