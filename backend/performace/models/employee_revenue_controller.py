"""Generated models for employee_revenue_controller. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from datetime import datetime
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field


class EmployeeRevenuePeriod(str, Enum):
    DAY = 'day'
    MONTH = 'month'
    YEAR = 'year'


@dataclass(slots=True)
class EmployeeRevenueBreakdownItemDto(DtoModel):
    serviceName: str
    count: float
    totalAmount: float


@dataclass(slots=True)
class EmployeeRevenueSummaryResponseDto(DtoModel):
    totalRevenue: float
    totalCommission: float
    netEarnings: float
    completedAppointments: float
    canceledAppointments: float
    period: EmployeeRevenuePeriod
    periodStart: datetime
    periodEnd: datetime


@dataclass(slots=True)
class EmployeeRevenueTrendPointDto(DtoModel):
    date: datetime
    amount: float
    label: str


EmployeeRevenueControllerGetBreakdownResponseDto: TypeAlias = list[EmployeeRevenueBreakdownItemDto]  # GET /employee/revenue/breakdown [200]


EmployeeRevenueControllerGetTrendResponseDto: TypeAlias = list[EmployeeRevenueTrendPointDto]  # GET /employee/revenue/trend [200]


__all__ = [
    "EmployeeRevenuePeriod",
    "EmployeeRevenueBreakdownItemDto",
    "EmployeeRevenueSummaryResponseDto",
    "EmployeeRevenueTrendPointDto",
    "EmployeeRevenueControllerGetBreakdownResponseDto",
    "EmployeeRevenueControllerGetTrendResponseDto",
]
