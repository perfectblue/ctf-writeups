from pathlib import Path
import time

import pyautogui

from python_speech_features import mfcc, logfbank
import scipy.io.wavfile as wav

import lib_generate


# for python_speech_features :|
import logging
logging.getLogger().setLevel(logging.CRITICAL)


WINDOW_POS = (0, 0)


def ustx_to_wav() -> Path:
    """
    NOTE: Very hardcoded to my own setup
    """
    # Reload current file
    pyautogui.moveTo(WINDOW_POS[0] + 20, WINDOW_POS[1] + 50)
    pyautogui.click()
    pyautogui.move(0, 125)
    pyautogui.click()
    # time.sleep(0.5)
    pyautogui.move(200, 0)
    pyautogui.click()

    # Export
    pyautogui.moveTo(WINDOW_POS[0] + 20, WINDOW_POS[1] + 50)
    pyautogui.click()
    pyautogui.move(0, 270)
    pyautogui.click()
    time.sleep(0.25)

    return Path('Export/song-01.wav')


def compare_mfcc_frames(frame_1, frame_2):
    x = 0
    for a, b in zip(frame_1, frame_2):
        x += abs(a - b) ** 2
    return x ** 0.5


VOWELS = '3AIOao{}'
CONSONANTS = '45DGLNSTfglprw'
DUMMY_VOWEL = '@'
DUMMY_CONSONANT = 'h'

all_possible_diphones = set()
all_possible_diphones |= set(VOWELS)

for c in CONSONANTS:
    all_possible_diphones.add(c)
    for v in VOWELS:
        all_possible_diphones.add(c + v)

ENOTE = 240
MELODY = [
    (69, ENOTE*2),  # A
    (64, ENOTE*2),  # E
    (72, ENOTE*2),  # C
    (71, ENOTE*1),  # B
    (69, ENOTE*1),  # A
    (71, ENOTE*2),  # B
    (67, ENOTE*2),  # G
    (62, ENOTE*2),  # D
    (71, ENOTE*2),  # B
    (65, ENOTE*2),  # F
    (60, ENOTE*2),  # C
    (69, ENOTE*2),  # A
    (67, ENOTE*1),  # G
    (65, ENOTE*1),  # F
    (67, ENOTE*2),  # G
    (69, ENOTE*2),  # A
    (71, ENOTE*2),  # B
    (74, ENOTE*2),  # D
    (72, ENOTE*4),  # C
]


def main():
    NFFT = 1103

    DO_GENERATE = True

    real_wav_fp = Path('song-01-real.wav')
    real_rate, real_sig = wav.read(real_wav_fp)
    real_mfcc = mfcc(real_sig, real_rate, nfft=NFFT)

    flag_list = []

    for syllable_num in range(len(flag_list), len(flag_list) + 1):
        syllable_dir = Path('Syllables') / f'{syllable_num:02d}'
        if DO_GENERATE: syllable_dir.mkdir()

        print(f'Syllable {syllable_num}')

        # Create all WAVs
        print('Creating wavs...')
        dp_to_wav_fp = {}
        for i, dp in enumerate(sorted(all_possible_diphones)):
            print(f'[{syllable_num} {flag_list}] {i}/134')

            flag = ''.join(flag_list + [dp])

            if lib_generate.convert_to_diphones(flag)[-1] not in [dp, dp + '@', 'h' + dp]:
                print('Combines wrong. SKIPPING')
                continue

            lib_generate.generate(flag, MELODY, check_assertions=False)
            if DO_GENERATE: wav_path = ustx_to_wav()
            new_wav_path = syllable_dir / f'{flag}.wav'
            if DO_GENERATE:
                for _ in range(10):
                    try:
                        wav_path.rename(new_wav_path)
                        break
                    except FileNotFoundError:
                        time.sleep(0.5)
                else:
                    raise
            dp_to_wav_fp[dp] = new_wav_path

        # Select best WAV
        print('Analyzing wavs...')
        best_diff = 99999999999999999999999999
        best_dp = None
        dps_and_diffs = []
        for i, dp in enumerate(sorted(all_possible_diphones)):
            print(f'{i}/134')

            if dp not in dp_to_wav_fp:
                continue

            dp_rate, dp_sig = wav.read(dp_to_wav_fp[dp])
            dp_mfcc = mfcc(dp_sig, dp_rate, nfft=NFFT)

            difference = 0
            for j, (real_frame, dp_frame) in enumerate(zip(real_mfcc, dp_mfcc)):
                difference += compare_mfcc_frames(real_frame, dp_frame)
            if difference < best_diff:
                best_diff = difference
                best_dp = dp
            dps_and_diffs.append((dp, difference))

        for dp, diff in sorted(dps_and_diffs, key=lambda x: x[1]):
            print(dp, diff)

        flag_list.append(best_dp)

    print(''.join(flag_list))


main()
