#!/usr/bin/env bash
# enable glob, error on unset variable, exit on error, pipe exit
set +f -ueo pipefail
# match nothing instead of being treated as string
shopt -s nullglob
shopt -s extglob
{
    cd /sys/kernel/iommu_groups
    iommu_groups=($(printf "%s\n" * | sort -V))
}
for i in "${!iommu_groups[@]}"; do
    group_num="${iommu_groups[i]}"
    {
        cd /sys/kernel/iommu_groups/"${group_num}"/devices
        group_devices=(*)
        group_devices_reset=(*/reset)
    }
    base_col="$((10 + (i % 2) * 10))"
    high_col="$((20 + (i % 2) * 10))"
    if [[ ${#group_devices_reset[@]} -eq 0 ]]; then
        echo -ne "\033[48;2;${high_col};${base_col};${base_col}m" # all devices in group cannot be reset, red bg tint
    else
        if [[ ${#group_devices[@]} == ${#group_devices_reset[@]} ]]; then
            echo -ne "\033[48;2;${base_col};${base_col};${base_col}m" # group is safe to use, no background tint
        else
            echo -ne "\033[48;2;${high_col};${high_col};${base_col}m" # some devices do not support resetting, orange bg tint
        fi
    fi
    printf "%b%03d%b\t" "\033[38;5;$((251 + (i % 2) * 4))m" "${group_num}" "\033[37m"
    for j in "${!group_devices[@]}"; do
        if [[ j -gt 0 ]]; then
            echo -ne $'\t'
        fi
        device_id="${group_devices[j]}"
        declare -A dev_data=()
        declare -a pci_data_raw=()
        eval "pci_data_raw=($(lspci -Dnnmms "${device_id}"))"
        DRIVER= PCI_ID= PCI_SLOT_NAME=
        source /sys/kernel/iommu_groups/"${group_num}"/devices/"${device_id}"/uevent
        {
            cd /sys/kernel/iommu_groups/"${group_num}"/devices/"${device_id}"
            children=(+([0-9a-f]):+([0-9a-f]):+([0-9a-f]).+([0-9a-f])/)
        }

        dev_data[slot]="${pci_data_raw[0]}"
        dev_data[pci_id]="${PCI_ID}"
        dev_data[class]="${pci_data_raw[1]}"
        case "${dev_data[class]}" in
            "Non-Volatile memory controller"*)
                dev_data[class]="Physical storage"
            ;;
            "VGA compatible controller"*)
                dev_data[class]="GPU"
            ;;
            "Non-Essential Instrumentation"*)
                dev_data[class]="Dummy device"
            ;;
        esac
        dev_data[vendor]="${pci_data_raw[2]}"
        case "${dev_data[vendor]}" in
            *"Advanced Micro Devices, Inc."*)
                dev_data[vendor]="AMD"
            ;;
            *"NVIDIA Corporation"*)
                dev_data[vendor]="NVIDIA"
            ;;
            *"Samsung Electronics Co Ltd"*)
                dev_data[vendor]="SAMSUNG"
            ;;
            *"Intel Corporation"*)
                dev_data[vendor]="INTEL"
            ;;
            *"Realtek Semiconductor Co., Ltd."*)
                dev_data[vendor]="REALTEK"
            ;;
        esac
        dev_data[device]="${pci_data_raw[3]}"
        dev_data[driver]="${DRIVER}"
        
        [ -e /sys/kernel/iommu_groups/"${group_num}"/devices/"${device_id}"/reset ] && \
            echo -ne "\033[32mReset\033[37m" # device can be reset
        [ -e /sys/kernel/iommu_groups/"${group_num}"/devices/"${device_id}"/reset ] && [[ ${#children[@]} -eq 0 ]] && echo -n ' '
        [[ ${#children[@]} -eq 0 ]] && \
            echo -ne "\033[34mEndpoint\033[37m" # device is an endpoint (libvirt will complain if you try to pass a device that isn't one)
        echo -ne $'\t'
        printf '%b\033[37m:%b\033[37m:%b\033[37m.%b\033[37m\t' \
            "\033[38;5;154m${dev_data[slot]:0:4}" \
            "\033[38;5;155m${dev_data[slot]:5:2}" \
            "\033[38;5;156m${dev_data[slot]:8:2}" \
            "\033[38;5;157m${dev_data[slot]:11:1}"
        printf '\033[37m[%b:%b\033[37m]\t' \
            "\033[38;5;193m${dev_data[pci_id]:0:4}" \
            "\033[38;5;194m${dev_data[pci_id]:5:4}"
        printf '%b%s\t' "\033[38;5;220m" "${dev_data[class]/ \[*\]}"
        printf '%b%s\t' "\033[38;5;147m" "${dev_data[vendor]/ \[*\]}"
        printf '%b%s\t' "\033[38;5;199m" "${dev_data[driver]:-}"
        echo -ne "\033[38;5;141m${dev_data[device]/ \[+([a-f0-9])\]}"

        # end line
        echo -ne "\033[0K"
        echo
    done
done | column -t -s $'\t' -o ' ' | {
    if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
        # normal terminal, output colored
        cat
    else 
        # pipe, requested, etc.. = monochrome
        sed -E $'s,\033\\[[0-9;]*[a-zA-Z],,gm'
    fi
}