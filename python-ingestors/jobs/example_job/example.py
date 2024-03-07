"""Example module to demonstrate how to create and run a job."""
import requests
from jobs.base_job import BaseJob

class ExampleJob(BaseJob):
    """Example class to demonstrate how to create a job."""
    url = "https://house-stock-watcher-data.s3-us-west-2.amazonaws.com/data/all_transactions.json"
    def run(self):
        """Run the job."""
        data = self.get_data()
        df = self.create_dataframe(data)
        file_path = f"s3://ev-dbt-python-data-engineering-raw-data-staging/test/example/{self.get_date_for_s3_path(self.get_current_utc_date())}/data.parquet"
        self.write_file_to_s3(file_path, df)

    def get_data(self) -> dict:
        """make an api request to get stock data."""
        response = requests.get(self.url)
        response.raise_for_status()
        return response.json()

if __name__ == "__main__":
    job = ExampleJob()
    job.run()