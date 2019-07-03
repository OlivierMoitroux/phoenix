/*
 * Copyright (C) 2019 Olivier Moitroux - All Rights Reserved
 *
 * Unauthorized copying/distribution of this file, via any medium is strictly
 * prohibited without the express permission of Olivier Moitroux.
 */
import 'package:flutter/material.dart';

final logo_large = Hero(
  tag: 'hero',
  child: CircleAvatar(
    backgroundColor: Colors.transparent,
    radius: 48.0,
    child: Image.asset('assets/logos/phoenix_long.png'),
  ),
);

