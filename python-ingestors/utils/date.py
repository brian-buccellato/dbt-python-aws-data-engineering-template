"""This module contains utility functions for interacting with dates"""
from datetime import datetime, timezone


class DateUtils:
    """Class for interacting with dates"""
    @staticmethod
    def get_current_utc_date() -> str:
        """Get the current in utc"""
        return datetime.now(tz=timezone.utc)

    @staticmethod
    def get_date_for_s3_path(date) -> str:
        """Get the current date formatted for an S3 path"""
        return date.strftime("%Y/%m/%d")