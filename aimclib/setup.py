#!/usr/bin/env python3
"""
Setup script for ALPINE AIMC Library
Compatible with Python 3.8+ and Ubuntu 22.04
"""

from setuptools import setup, find_packages
import os

# Read the README file
def read_readme():
    readme_path = os.path.join(os.path.dirname(__file__), "README.md")
    if os.path.exists(readme_path):
        with open(readme_path, "r", encoding="utf-8") as f:
            return f.read()
    return "ALPINE AIMC Library - Python 3 implementation"

# Read requirements
def read_requirements():
    requirements_path = os.path.join(os.path.dirname(__file__), "requirements.txt")
    if os.path.exists(requirements_path):
        with open(requirements_path, "r", encoding="utf-8") as f:
            return [line.strip() for line in f if line.strip() and not line.startswith("#")]
    return ["numpy>=1.21.0"]

setup(
    name="alpine-aimc",
    version="1.0.0",
    author="Joshua Klein",
    author_email="joshua.klein@epfl.ch",
    description="ALPINE AIMC Library - Python 3 implementation for Analog In-Memory Computing",
    long_description=read_readme(),
    long_description_content_type="text/markdown",
    url="https://github.com/epfl-alpine/aimc-library",
    packages=find_packages(),
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Intended Audience :: Science/Research",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Topic :: Scientific/Engineering",
        "Topic :: Software Development :: Libraries :: Python Modules",
    ],
    python_requires=">=3.8",
    install_requires=read_requirements(),
    extras_require={
        "dev": [
            "pytest>=6.0.0",
            "black>=22.0.0",
            "flake8>=4.0.0",
            "mypy>=0.950",
        ],
        "viz": [
            "matplotlib>=3.5.0",
            "seaborn>=0.11.0",
        ],
        "jupyter": [
            "jupyter>=1.0.0",
            "ipython>=7.0.0",
        ],
    },
    entry_points={
        "console_scripts": [
            "aimc-example=aimc.example:main",
        ],
    },
    include_package_data=True,
    zip_safe=False,
    keywords="aimc analog in-memory computing machine learning neural networks",
    project_urls={
        "Bug Reports": "https://github.com/epfl-alpine/aimc-library/issues",
        "Source": "https://github.com/epfl-alpine/aimc-library",
        "Documentation": "https://github.com/epfl-alpine/aimc-library/wiki",
    },
)
