# libasound-d

This package contains [ALSA](http://www.alsa-project.org/main/index.php/Main_Page)
[library headers](http://www.alsa-project.org/main/index.php/ALSA_Library_API)
translated to D.

dstep was used to generate the binding which was then modified to build properly.

You will need to add "asound" to your "libs" or "posix-libs" section in your project
dub.json file to link to the libasound2 library.

## Issues

libasound2 makes heavy use of anonymous structures. When allocating such structures
macros are often used to allocate the structure on the stack using alloca(). Currently
these macros have not been translated to a D equivalent. If anyone has any good ideas
for a mixin template or something, please let me know.

### Example alloca() structure allocation

This example is for the **snd_seq_port_info_t** structure.

**C code**
```
snd_seq_port_info_t *port_info = NULL;
snd_seq_port_info_alloca (&port_info);
```

**Equivalent D code**
```
import core.stdc.stdlib : alloca;
import core.stdc.string : memset;

snd_seq_port_info_t *port_info;
port_info = cast(typeof(port_info))alloca(snd_seq_port_info_sizeof());
memset(port_info, 0, snd_seq_port_info_sizeof());
```

## Release history

- v2.0.0 (2023-05-30)
  - First release

## License

ALSA library and these bindings are licensed under the terms of LGPL-2.1 or later.
See the file COPYING for more details.

## Authors

libasound2 has several authors, including:
Jaroslav Kysela <perex@perex.cz>
Abramo Bagnara <abramo@alsa-project.org>
Takashi Iwai <tiwai@suse.de>

See libasound2 sources for more details.

This D binding was created by "Element Green" <element-d@elementsofsound.org>.
