#!/usr/bin/env python
from os import environ
from datetime import datetime
from argparse import ArgumentParser
import boto3

def sort_amis_by_creation_date(amis):
    return sorted(amis, key=lambda ami: ami.creation_date)

def get_amis_by_name(resource_ec2, name):
    filters = [{'Name':'name', 'Values':[name]}]
    return list(resource_ec2.images.filter(Filters=filters))

def ami_string(ami):
    return '{}, {}, {}'.format(ami.name, ami.creation_date, ami.id)

if __name__ == '__main__':
    parser = ArgumentParser(description="get the latest AMI id")
    parser.add_argument('-a', '--aws-access-key', default=environ.get('AWS_ACCESS_KEY_ID', None))
    parser.add_argument('-s', '--aws-secret-key', default=environ.get('AWS_SECRET_ACCESS_KEY', None))
    parser.add_argument('-r', '--aws-region', default=environ.get('AWS_DEFAULT_REGION', None))
    parser.add_argument('--list-all', default=False, action="store_true", help='list all AMIs which match name_filter.')
    parser.add_argument('name_filter')
    args = parser.parse_args()

    if args.aws_access_key and args.aws_secret_key and args.aws_region:
            boto3.setup_default_session(
              aws_access_key_id     = args.aws_access_key,
              aws_secret_access_key = args.aws_secret_key,
              region_name           = args.aws_region,
            )

    resource_ec2 = boto3.resource('ec2')

    amis = get_amis_by_name(resource_ec2, args.name_filter)

    sorted_amis = sort_amis_by_creation_date(amis)

    if args.list_all:
        for ami in sorted_amis:
            print(ami_string(ami))
    else:
        ami = sorted_amis[-1]
        print(ami_string(ami))
