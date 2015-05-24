# CHANGELOG for wal-e

This file is used to list changes made in each version of wal-e.

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
