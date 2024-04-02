"""This module contains utility functionality for interacting with polars"""

import s3fs
import polars as pl
import pyarrow.dataset as ds


class PolarsUtils:
    """Utility class for interacting with polars"""

    fs = s3fs.S3FileSystem()

    def write_parquet_file_to_s3(self, file_path: str, df: pl.DataFrame):
        """Write a parquet file to S3"""

        with self.fs.open(file_path, "wb") as file:
            df.write_parquet(file)

    def write_json_file_to_s3(self, file_path: str, df: pl.DataFrame):
        """Write a json file to S3"""

        with self.fs.open(file_path, "wb") as file:
            df.write_ndjson(file)

    def create_dataframe(self, data: dict) -> pl.DataFrame:
        """Create a polars dataframe from a dictionary"""
        return pl.DataFrame(data)

    def read_parquet_file_from_s3(self, file_path: str) -> pl.DataFrame:
        """Read a file from S3 and return as a polars dataframe"""
        dataset = ds.dataset(file_path, filesystem=self.fs, format="parquet")
        return pl.scan_pyarrow_dataset(dataset)
