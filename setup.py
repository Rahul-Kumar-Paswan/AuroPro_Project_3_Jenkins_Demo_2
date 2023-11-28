from setuptools import setup, find_packages

setup(
    name="flask_app",
    version='1.0.1',
    packages=find_packages(),
    description='A simple Python flask package',
    author='rahul@paswan',
    install_requires=[
        "Flask==2.1.1",
        "mysql-connector-python==8.0.28",
        "werkzeug==2.0.2",
        "setuptools==68.2.2",
        "wheel==0.41.2"
    ],
)
