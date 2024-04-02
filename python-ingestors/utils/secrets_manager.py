"""This module will contain functionality for interacting with AWS Secrets Manager"""

import json
import boto3
from botocore.exceptions import ClientError


# disabling as this class will add more methods in the future,
# otherwise can be converted to a dataclass
# pylint: disable=too-few-public-methods
class SecretsManagerUtils:
    """Utility class for interacting with AWS Secrets Manager"""

    def __init__(self) -> None:
        self.secrets_client = boto3.client("secretsmanager")

    def get_secret_value(self, secret_name: str) -> str:
        """Get the value of a secret"""
        try:
            response = self.secrets_client.get_secret_value(SecretId=secret_name)
            return json.loads(response["SecretString"])
        except ClientError as error:
            raise error
