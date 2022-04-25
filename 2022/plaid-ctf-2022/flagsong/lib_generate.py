# made with OpenUtau v0.0.705.0

from typing import List

# X-SAMPA
vowels = '3AIOao{}'
consonants = '45DGLNSTfglprw'
dummy_vowel = '@'
dummy_consonant = 'h'

def convert_to_diphones(FLAG: str) -> List[str]:
    diphones = []

    # convert to CVCVCV...
    diphone = ''
    for i in FLAG:
        if len(diphone) == 0:
            if i in vowels:
                diphones.append(dummy_consonant + i)
            else:
                diphone = i
        else:
            if i in vowels:
                diphones.append(diphone + i)
                diphone = ''
            else:
                diphones.append(diphone + dummy_vowel)
                diphone = i
    if len(diphone) > 0:
        diphones.append(diphone + dummy_vowel)

    return diphones

def generate(FLAG: str, MELODY: list, *, check_assertions:bool=False) -> None:
    print(f'Generating with flag {FLAG} and melody {MELODY}')

    if check_assertions:
        assert(set(vowels+consonants) == set(FLAG))
        assert(len(FLAG) == 29)

    diphones = convert_to_diphones(FLAG)

    if check_assertions:
        assert len(MELODY) == len(diphones)

    header = '''name: flagsong
comment: ''
output_dir: Vocal
cache_dir: UCache
ustx_version: 0.5
bpm: 120
beat_per_bar: 4
beat_unit: 4
resolution: 480
expressions:
  dyn:
    name: dynamics (curve)
    abbr: dyn
    type: Curve
    min: -240
    max: 120
    default_value: 0
    is_flag: false
    flag: ''
  pitd:
    name: pitch deviation (curve)
    abbr: pitd
    type: Curve
    min: -1200
    max: 1200
    default_value: 0
    is_flag: false
    flag: ''
  clr:
    name: voice color
    abbr: clr
    type: Options
    min: 0
    max: -1
    default_value: 0
    is_flag: false
    options: []
  eng:
    name: resampler engine
    abbr: eng
    type: Options
    min: 0
    max: 1
    default_value: 0
    is_flag: false
    options:
    - ''
    - worldline
  vel:
    name: velocity
    abbr: vel
    type: Numerical
    min: 0
    max: 200
    default_value: 100
    is_flag: false
    flag: ''
  vol:
    name: volume
    abbr: vol
    type: Numerical
    min: 0
    max: 200
    default_value: 100
    is_flag: false
    flag: ''
  atk:
    name: attack
    abbr: atk
    type: Numerical
    min: 0
    max: 200
    default_value: 100
    is_flag: false
    flag: ''
  dec:
    name: decay
    abbr: dec
    type: Numerical
    min: 0
    max: 100
    default_value: 0
    is_flag: false
    flag: ''
  gen:
    name: gender
    abbr: gen
    type: Numerical
    min: -100
    max: 100
    default_value: 0
    is_flag: true
    flag: g
  genc:
    name: gender (curve)
    abbr: genc
    type: Curve
    min: -100
    max: 100
    default_value: 0
    is_flag: false
    flag: ''
  bre:
    name: breath
    abbr: bre
    type: Numerical
    min: 0
    max: 100
    default_value: 0
    is_flag: true
    flag: B
  brec:
    name: breathiness (curve)
    abbr: brec
    type: Curve
    min: -100
    max: 100
    default_value: 0
    is_flag: false
    flag: ''
  lpf:
    name: lowpass
    abbr: lpf
    type: Numerical
    min: 0
    max: 100
    default_value: 0
    is_flag: true
    flag: H
  mod:
    name: modulation
    abbr: mod
    type: Numerical
    min: 0
    max: 100
    default_value: 0
    is_flag: false
    flag: ''
  alt:
    name: alternate
    abbr: alt
    type: Numerical
    min: 0
    max: 16
    default_value: 0
    is_flag: false
    flag: ''
  shft:
    name: tone shift
    abbr: shft
    type: Numerical
    min: -36
    max: 36
    default_value: 0
    is_flag: false
    flag: ''
  shfc:
    name: tone shift (curve)
    abbr: shfc
    type: Curve
    min: -1200
    max: 1200
    default_value: 0
    is_flag: false
    flag: ''
  tenc:
    name: tension (curve)
    abbr: tenc
    type: Curve
    min: -100
    max: 100
    default_value: 0
    is_flag: false
    flag: ''
  voic:
    name: voicing (curve)
    abbr: voic
    type: Curve
    min: 0
    max: 100
    default_value: 100
    is_flag: false
    flag: ''
tracks:
- singer: Violet Aura Split VCCV
  phonemizer: OpenUtau.Core.DefaultPhonemizer
  mute: false
  solo: false
  volume: 0
voice_parts:
- name: New Part
  comment: ''
  track_no: 0
  position: 0
  notes:
'''

    footer = '''  curves: []
wave_parts: []
'''

    note = '''  - position: {}
    duration: {}
    tone: {}
    lyric: {}
    pitch:
      data:
      - {{x: -40, y: {}, shape: io}}
      - {{x: 40, y: 0, shape: io}}
      snap_first: true
    vibrato: {{length: 75, period: 175, depth: 25, in: 10, out: 10, shift: 0, drift: 0}}
    note_expressions: []
    phoneme_expressions: []
    phoneme_overrides: []
'''

    song = ''
    position = 0
    prev_tone = MELODY[0][0]
    for lyric, (tone, duration) in zip(diphones, MELODY):
        if check_assertions:
            assert duration % 240 == 0
        song += note.format(position, duration, tone, lyric, (prev_tone-tone)*10)
        position += duration
        prev_tone = tone

    with open('song.ustx','w') as f:
        f.write(header + song + footer)
