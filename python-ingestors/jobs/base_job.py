"""This module will contain the base class for all jobs."""

from utils.date import DateUtils
from utils.polars_helper import PolarsUtils
from utils.s3 import S3Utils
from utils.redshift import RedshiftUtils
from utils.config.global_config import GlobalConfig


class BaseJob(PolarsUtils, S3Utils, DateUtils, RedshiftUtils, GlobalConfig):
    """Base class for all jobs. Contains common functionality."""
