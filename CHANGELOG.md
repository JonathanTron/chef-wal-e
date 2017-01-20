# CHANGELOG for wal-e

This file is used to list changes made in each version of wal-e.

## 0.6.3

* Make sure we're using gevent 0.13.8 on Ubuntu 12.04

## 0.6.2

* Update Greenlet installation to not install binary on Ubuntu 12.04

## 0.6.1

* Update wal-e default installed version to 0.8.1
* Ensure Greenlet 0.4.9 is installed on Ubuntu 12.04 as 0.4.10 brings
  incompatibility due to binary compiled with Python 2.7.4 which is not
  compatible with Python 2.7.3 (which is the last version available on
  Ubuntu 12.04)

## 0.6.0

* Update wal-e default installed version to 0.8.0
* Drop testing on Ruby 1.9.3

## 0.5.2

* Fix specs and README

## 0.5.1

* Update wal-e default installed version to 0.7.3
* Install `libffi-dev` package so that wal-e installs correctly

## 0.5.0

* Switch from `daemontools` (`envdir`) to `runit` (`chpst`)

## 0.4.0

* Update wal-e default installed version to 0.7.1
* Move from minitest to ChefSpec

## 0.3.0

* Allow setting a Boto S3 default host for bucket in other region than default

## 0.2.0:

* Fix wrong attributes nesting for `["wal-e"]["s3"]["use_encrypted_data_bag"]`

## 0.1.0:

* Initial release of wal-e
