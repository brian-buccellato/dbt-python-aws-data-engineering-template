"""This module will contain global configuration parameters for ingestion jobs."""

import os
import logging
import redshift_connector
from dotenv import load_dotenv
from utils.secrets_manager import SecretsManagerUtils

logger = logging.getLogger(__name__)


class GlobalConfig(SecretsManagerUtils):
    """Class for interacting with global configuration parameters"""

    def __init__(self) -> None:
        load_dotenv()
        super().__init__()

    @property
    def default_secret_data(self) -> dict:
        """Get the default secret"""
        return self.get_secret_value(os.environ["DEFAULT_SECRET_NAME"])

    @property
    def redshift_conn(self) -> redshift_connector.Connection:
        """This method returns a redshift connection for redshift"""
        redshift_connector.paramstyle = "pyformat"
        return redshift_connector.connect(
            host=self.default_secret_data["REDSHIFT_HOST"],
            database=self.default_secret_data["REDSHIFT_DATABASE"],
            port=5439,
            user=self.default_secret_data["REDSHIFT_USER"],
            password=self.default_secret_data["REDSHIFT_PASSWORD"],
        )

    @property
    def default_s3_bucket(self) -> str:
        """This method returns the s3 bucket name"""
        return self.default_secret_data["DEFAULT_S3_BUCKET"]

    @property
    def environment(self) -> str:
        """This method returns the environment"""
        return os.environ["ENV"]
