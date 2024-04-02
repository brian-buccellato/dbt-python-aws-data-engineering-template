"""This module contains utility functions for interacting with AWS Redshift"""

from retry import retry
import redshift_connector


class RedshiftUtils:
    """Utility class for interacting with AWS Redshift"""

    @staticmethod
    @retry(tries=3, delay=2, backoff=2, max_delay=30)
    def query_redshift(query: str, rs_conn) -> list:
        """Query Redshift with built in retry"""
        with rs_conn.cursor() as cursor:
            cursor.execute(query)
            return cursor.fetchall()

    @staticmethod
    def copy_to_redshift(
        source_bucket_key: str,
        copy_options: str,
        target_table: str,
        rs_conn: redshift_connector.Connection,
        schema: str = "raw_layer",
    ) -> None:
        """Copy data to Redshift with built in retry"""
        with rs_conn.cursor() as cursor:
            query = f"""
            copy {schema}.{target_table}
            from '{source_bucket_key}'
            iam_role default
            {copy_options}
            """
            cursor.execute(query)
            rs_conn.commit()
            cursor.close()
