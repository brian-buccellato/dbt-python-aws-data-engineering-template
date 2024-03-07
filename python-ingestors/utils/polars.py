"""This module contains utility functionality for interacting with polars"""
import polars as pl
import s3fs

class PolarsUtils:
    """Utility class for interacting with polars"""
    fs = s3fs.S3FileSystem()

    def write_file_to_s3(self, file_path: str, df: pl.DataFrame):
        """Write a file to S3"""

        with self.fs.open(file_path, 'wb') as file:
            df.write_parquet(file)

    def create_dataframe(self, data: dict) -> pl.DataFrame:
        """Create a polars dataframe from a dictionary"""
        return pl.DataFrame(data)