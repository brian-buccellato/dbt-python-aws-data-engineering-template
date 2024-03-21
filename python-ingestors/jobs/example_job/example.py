"""Example module to demonstrate how to create and run a job."""

import requests
from jobs.base_job import BaseJob


class ExampleJob(BaseJob):
    """Example class to demonstrate how to create a job."""

    url = "https://house-stock-watcher-data.s3-us-west-2.amazonaws.com/data/all_transactions.json"
    table = "stock_transactions"

    def run(self) -> None:
        """Run the job."""
        data = self.get_data()
        df = self.create_dataframe(data)
        path_prefix = (
            f"{self.environment}/example/{self.get_date_for_s3_path(self.get_current_utc_date())}"
        )
        s3_file_path = f"s3://{self.default_s3_bucket}/{path_prefix}/data.json"
        self.write_json_file_to_s3(s3_file_path, df)
        self.copy_to_redshift(
            source_bucket_key=s3_file_path,
            copy_options="json 'auto'",
            target_table=self.table,
            rs_conn=self.redshift_conn
        )
        self.redshift_conn.close()

    def get_data(self) -> dict:
        """make an api request to get stock data."""
        response = requests.get(self.url, timeout=60)
        response.raise_for_status()
        return response.json()


if __name__ == "__main__":
    job = ExampleJob()
    job.run()
