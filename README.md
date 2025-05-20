# asrock-nct6683

This codebase provides an updated driver for `nct6683` which supports controlling case fans via pwm.

This enables tools like `lm-sensors`, `fancontrol`, `fan2go`, etc on additional motherboards which use NCT6683D-T for fan control.

## Supported Motherboards

* ASRock B550 Taichi Razer Edition
* ASRock B650I Lightning WiFi
* ASRock A620I Lightning WiFi

## Installation Instructions

### DKMS

1) Install `dkms` on your platform
2) Clone this repo
3) Build the repo and install using dkms
4) (Optional) Set the `nct6683` driver to load (e.g. through `/etc/conf.d/lm_sensors` or `/etc/modules-load.d/`)

#### Arch Linux

```bash
$ sudo pacman -Syu dkms git
$ git clone https://github.com/branchmispredictor/asrock-nct6683.git && cd asrock-nct6683
$ sudo make dkms
```

## Configuration

* `force`: Set to one to enable support for unknown vendors (bool)
* `pwm_set_delay`: Adds a delay in usec after setting pwm values (int)
    * This helps with programs like fan2go which immediately tries to read the PWM value after setting it
