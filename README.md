[![Build Status](https://travis-ci.org/mauricioklein/etventure-collage-maker.svg?branch=master)](https://travis-ci.org/mauricioklein/etventure-collage-maker)
[![Code Climate](https://codeclimate.com/github/mauricioklein/etventure-collage-maker/badges/gpa.svg)](https://codeclimate.com/github/mauricioklein/etventure-collage-maker)
[![Test Coverage](https://codeclimate.com/github/mauricioklein/etventure-collage-maker/badges/coverage.svg)](https://codeclimate.com/github/mauricioklein/etventure-collage-maker/coverage)
[![Issue Count](https://codeclimate.com/github/mauricioklein/etventure-collage-maker/badges/issue_count.svg)](https://codeclimate.com/github/mauricioklein/etventure-collage-maker)
[![Dependency Status](https://gemnasium.com/badges/github.com/mauricioklein/etventure-collage-maker.svg)](https://gemnasium.com/github.com/mauricioklein/etventure-collage-maker)

# Etventure Collage Maker

**Etventure Collage Maker** is a Ruby gem which allows to fetch images from Flickr based on some keywords and create a collage with these images.

## Dependencies

This gem depends on:

* Ruby v2.3.1 or above;
* [ImageMagick](http://www.imagemagick.org/script/index.php) v6.8.9-9 or above;
* libmagickwand-dev;

Assuming an Ubuntu distribution, *ImageMagick* and *libmagickwand-dev* can be installed as below:

```sh
$ sudo apt-get update

$ sudo apt-get install imagemagick

$ sudo apt-get install libmagickwand-dev  
```

## ImageMagick setup

This gem uses the command *montage* of ImageMagick to create the collage.

Montage command is using font *DejaVu-Sans* by default, which is a font that's normally available in the great majority of Linux distributions.

If this font isn't available on you system, it can be easily changed by defining the following environment variable:

```sh
$ export IMAGEMAGICK_FONT="[Put the font name here]"
```

The list of all available ImageMagick fonts can be found running the command below:

```sh
$ convert -list font
```

## Gem setup

To query images from Flickr, a Flickr API key is necessary.

> If you don't have a Flickr API key yet, please refer to [Flickr services webpage](https://www.flickr.com/services/api/misc.api_keys.html) to create one.

So, to setup your Flickr API key and shared secret, set the following environent variables:

```sh
$ export FLICKR_API_KEY="[Your Flickr API key]"
$ export FLICKR_SHARED_SECRET="[Your Flickr shared secret]"
```

Now we're ready to install necessary gems:

    $ bundle install

## Tests

To run the automated tests, simple run:

    $ rspec

## Building and Installing

To build and install the gem, we use Rake tasks to automate all related operations.

So, first we build the gem:

    $ rake build

Once the gem is build, we can install it in our local gems repository:

    $ rake install

Now we're ready to use **Etventure Collage Maker**.

## Running

**Etventure Collage Maker** offers a command line interface.

To run the CLI, just type:

    $ etventure-collage-maker

The main CLI task is *create*, which receives the arguments passed by user and perform all collage related steps (search images, download them and create collage).

To check the arguments accepted by _create_ task, run:

    $ etventure-collage-maker help create

Example:

Let' suppose we want to create a collage with images related to the following keywords: **Germany**, **Berlin**, **Europe**, **Ruby** and **Software**.

So, we can simple run:

    $ etventure-collage-maker create -k Germany,Berlin,Europe,Ruby,Software -o my_collage.jpg

The command above will fetch 5 images, based in the informed keywords, and query another 5 images using random keywords from _/usr/share/dict/words_ file.

The collage will be saved in *my_collage.jpg*
