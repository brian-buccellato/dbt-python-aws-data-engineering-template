from utils.date import DateUtils
from utils.polars import PolarsUtils
from utils.s3 import S3Utils

class BaseJob(PolarsUtils, S3Utils, DateUtils):
    """Base class for all jobs. Contains common functionality."""
    pass