import json
import os
import random
from argparse import ArgumentParser

'''
This script removes duplicate files from project found by duplicate code detector.
'''
if __name__ == '__main__':
    parser = ArgumentParser()
    parser.add_argument("--project", dest="project_path",
                        help="path to the project from which duplicates should be removed", required=True)
    parser.add_argument("--duplicates_data", dest="duplicates_data_path",
                        help="data from DuplicateCodeDetector", required=True)
    args = parser.parse_args()

    project_path = args.project_path
    duplicates_data_path = args.duplicates_data_path

    with open('DuplicateCodeDetector/DuplicateCodeDetector.csproj.json') as f:
        duplicates = json.load(f)

    for duplicate_group in duplicates:  # type: list
        # Leave one from the duplicate group to the dataset
        duplicate_group.remove(random.choice(duplicate_group))
        for duplicate_path in duplicate_group:  # type: str
            os.remove(os.path.join(project_path, duplicate_path))
