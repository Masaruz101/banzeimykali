# banzeimykali

`banzeimykali.sh` คือสคริปต์ตั้งค่า/แก้ปัญหา Kali Linux แบบ all-in-one ที่ต่อยอดมาจาก
[pimpmykali](https://github.com/Dewalt-arch/pimpmykali) ของ **Dewalt** โดยปรับแต่งและดูแลต่อโดย **H1r0t0**

> Original project: pimpmykali.sh (Author: Dewalt)
> Modified/maintained as: banzeimykali.sh (Modify: H1r0t0)

**Release: v1.0.0** — รีลีสแรกของฉบับที่ปรับเป็นของตัวเอง (แยกเลขเวอร์ชันออกจาก upstream pimpmykali)

## คืออะไร

สคริปต์เดียวที่รวมการแก้ปัญหา/ติดตั้งเครื่องมือที่พบบ่อยหลังลง Kali Linux ใหม่ ๆ เช่น
pip/pip3 ชนกัน, samba protocol, golang, grub mitigations, impacket, docker-compose,
nmap scripts ที่เสีย, รวมถึงการติดตั้งเครื่องมือ pentest/red-team อื่น ๆ (netexec, certipy,
coercer, autorecon, ProjectDiscovery suite ฯลฯ) และของเตรียมคอร์สเรียนของ TCM Security
(MAPT, PBB, PEH WebLab, Hacking API, IoT, C# 101)

ทำงานผ่านระบบเมนูแบบ interactive (`sudo ./banzeimykali.sh`) หรือผ่าน command-line flag
(`sudo ./banzeimykali.sh --<option>`) ก็ได้

## Requirements

- Kali Linux เท่านั้น (สคริปต์เช็ค distro ตอนเริ่ม ถ้าไม่ใช่ Kali จะออกทันที — WSL ไม่รองรับ)
- ต้องรันด้วย root/sudo

## วิธีใช้งาน

```bash
chmod +x banzeimykali.sh
sudo ./banzeimykali.sh            # เปิดเมนู interactive
sudo ./banzeimykali.sh --help     # ดู flag ทั้งหมดที่ใช้ผ่าน command-line ได้
```

## เมนูหลัก (interactive menu)

| Key | รายการ | คำอธิบาย |
|---|---|---|
| 1 | Fix Missing | pip, pip3, golang, gedit, nmap fix, build-essential |
| 2 | Fix /etc/samba/smb.conf | ตั้ง client min/max protocol ถ้ายังไม่ได้ตั้ง |
| 3 | Fix Golang | ติดตั้ง golang, เติม GOPATH ใน .zshrc/.bashrc |
| 4 | Fix Grub | เติม `mitigations=off` |
| 5 | Reinstall Impacket | ติดตั้ง impacket ใหม่จาก kali repo |
| 6 | Enable Root Login | ติดตั้ง kali-root-login |
| 7 | Fix Docker-Compose | ติดตั้ง docker-compose และ docker.io |
| 8 | Fix nmap scripts | อัปเดต clamav-exec.nse และ http-shellshock.nse |
| 9 | Pimpmyupgrade | apt upgrade พร้อมตรวจ vbox/vmware |
| 0 | Fix All | รัน `fix_missing` (รวมเครื่องมือ/ฟิกซ์อีกกว่า 50 รายการ ไม่ใช่แค่ข้อ 1-8) บวก autoremove/fix-broken/vm checks |
| N | NEW VM SETUP | รันตอนตั้งเครื่องใหม่ครั้งแรก |
| = | Banzeimykali-Mirrors | หา kali mirror ที่เร็วที่สุด |
| T | Reconfigure Timezone | ตั้ง timezone ใหม่ |
| K | Reconfigure Keyboard | ตั้ง keyboard layout ใหม่ |

### Stand-alone / Courses

| Key | รายการ |
|---|---|
| A | MAPT Course Setup |
| B | Practical Bugbounty Labs |
| E | PEH Course WebApp Labs |
| O | Hacking API Course Setup |
| Y | IoT & Hardware Hacking Course Setup |
| Z | C# 101 For Hackers Course Setup |

### Utils

| Key | รายการ |
|---|---|
| U | Install Netexec (nxc) |
| P | Download Lin/WinPeas |
| S | Fix Kali Signing Key |
| V | Install MS-VSCode |
| ! | Nuke Impacket (ติดตั้ง impacket 0.9.19) |
| @ | Install Nessus |
| $ | Nuke Nessus |
| % | CrackMapExec |
| C | Certipy (AD CS enum/abuse) |
| D | Coercer |
| F | AutoRecon |
| L | Start Engagement Log (asciinema) |
| R | ProjectDiscovery Suite (subfinder, httpx-toolkit, nuclei, dnsx, katana) |
| W | Clean Kali (apt clean/autoremove, journalctl vacuum, VM Zero-Out แบบ optional) |
| ^ | Install Everything — `apt install kali-linux-everything` (เปิด root login อัตโนมัติ ใช้พื้นที่หลาย GB ใช้เวลานาน) |

## Command-line flags

ดูรายการทั้งหมดแบบสดได้ด้วย `sudo ./banzeimykali.sh --help` แต่สรุปกลุ่มหลัก ๆ ไว้ดังนี้

```
--auto / --autonoroot / --all / --newvm   modes สำหรับรันแบบไม่ต้องเข้าเมนู
--everything   apt install kali-linux-everything (เปิด root login อัตโนมัติ, ใช้พื้นที่หลาย GB)
--ghidra --bloodhound --certipy --coercer --netexec --cme
--dockercompose --pdsuite --subfinder --httpx --nuclei --dnsx --katana
--cleankali --zeroout
--mapt --pbb --pehweblab --api --iot --csharp     (course setup)
--pip2 --pip3 --pipx --fixpip
```

## ไฟล์ในโปรเจกต์

| ไฟล์ | รายละเอียด |
|---|---|
| `banzeimykali.sh` | สคริปต์หลัก |
| `clean-kali.sh` | ตัวเสริมแบบ standalone (ภาษาไทย) สำหรับ apt clean/autoremove + VM Zero-Out เหมาะกับตอนที่ไม่ต้องการรันสคริปต์หลักทั้งตัว |
| `fixed-http-shellshock.nse` | nmap script เวอร์ชันแก้ไขแล้ว ใช้แทนที่ `http-shellshock.nse` ที่เสียบน Kali (เรียกใช้งานจากเมนู 8 / `--nmap`) |
| `changelog.txt` | ประวัติการแก้ไขของ pimpmykali ฉบับดั้งเดิม (อัปเดตล่าสุดถึง 1.8.1b) |

## Release Notes

### v1.0.0
แยกเลขเวอร์ชันออกจาก pimpmykali (เดิมแสดง `Rev: 2.0.5` ของ upstream) เริ่มนับเวอร์ชันของฉบับนี้เองที่ `v1.0.0`
ผ่านการ audit เต็มไฟล์ก่อนปล่อยรีลีสแรก พบและแก้ไขดังนี้:

**Bug fixes**
- `fix_nxc_symlinks`: loop เดิมอ้างตัวแปร `cme_symlink_array`/`$cme_symlink_array_file` ที่เป็นของฟังก์ชัน cme เก่า (ไม่มีอยู่จริงในฟังก์ชันนี้) ทำให้ไม่เคยสร้าง symlink ของ netexec ให้ผู้ใช้เลย แก้เป็น `nxc_symlink_array`/`$nxc_symlink_array_file`
- `fix_pip2_pip3`: ตรวจตัวแปรผิดชื่อ (`pipcheck` ที่ไม่ถูกตั้งค่าที่ไหน ทั้งที่ตั้งค่าไว้ในชื่อ `pip_check`) ทำให้เคสที่ `/usr/bin/pip` ยังเป็น python2 ไม่ถูกซ่อมแซมจริง แก้ให้ตรวจ `$pip_check` ให้ตรงกัน พร้อม init ค่าเริ่มต้นกัน error เงียบ ๆ ตอนไม่มี `/usr/bin/pip`
- `fix_ghidra`: ลบ argument `${WGET_STATUS}` ที่ไม่เคยถูกประกาศไว้ที่ไหนในสคริปต์ ซึ่งทำให้ `wget` ได้ URL เปล่ามาเป็น argument แทรก เสี่ยงทำให้ไฟล์ ghidra.zip ที่โหลดมาเสีย (เพราะ `-O` รวมผลลัพธ์จากหลาย URL เข้าไฟล์เดียว)
- `fix_netexec`: เพิ่มการตรวจ pipx venv เดิมของ netexec ว่า interpreter พังหรือไม่ (เช่นกรณี python ถูกอัปเกรดจาก 3.11 เป็น 3.12 แล้ว venv เก่าชี้ไป python ที่ไม่มีอยู่แล้ว) ถ้าพังจะ `pipx uninstall` ก่อนแล้วค่อย `--force` install ใหม่ กันไม่ให้ symlink ชี้ไปยัง venv ที่ใช้งานไม่ได้ (เจอจากการทดสอบจริงบนเครื่อง Kali ที่เคยอัปเกรด python มาก่อน)
- `fix_nmap`: path ของ `fixed-http-shellshock.nse` ชี้ไปที่ `./addons/` ที่ไม่มีอยู่จริง (และพึ่ง CWD ตอนรัน) ทำให้ฟังก์ชันนี้ใช้ไฟล์ที่ bundle มาในนี้ไม่ได้เลย แก้ให้ resolve path จากตำแหน่งของสคริปต์เอง (`$SCRIPT_DIR`) แทน
- `hacking_api_prereq`: ลบ `chmod -R 777 $HOME/peh/labs ...` ที่เป็นโค้ด copy-paste หลงมาจากฟังก์ชัน PEH (path/`$HOME` ผิด ไม่เกี่ยวกับ crAPI lab ของฟังก์ชันนี้เลย)
- `confirm_menu_choice`: typo `${menuinpu_to_upper}` (ขาดตัว t) ทำให้ข้อความยืนยันเมนูโชว์ค่าว่างเสมอ

**Hardening / cleanup**
- ลบ `eval` ที่ไม่จำเป็นในจุดที่ไม่ได้พึ่ง redirection ผ่านตัวแปร (gowitness, impacket 0.9.19 installer, perform_copy_to_root, docker/docker-compose calls, sublime keyring setup) — คง `eval` ไว้เฉพาะจุดที่จำเป็นจริง (เช่น `$silent` redirection, GOPATH echo block) เพราะลบแล้วจะทำให้พฤติกรรมเปลี่ยน
- เปลี่ยนไฟล์ temp ที่ดาวน์โหลดมาแล้ว execute ต่อ (`google-chrome*.deb`, `spike*.deb`, `impacket-0.9.19.tar.gz`, `packages.microsoft.gpg`) ให้ใช้ `mktemp` แทนชื่อไฟล์คงที่ใน `/tmp`
- ลบ 5 ฟังก์ชันที่ไม่ถูกเรียกใช้จากที่ไหนเลย: `fix_liblibc`, `install_cargo`, `install_docker`, `install_rustup`, `kali_signingkey_silent`
- แก้ pattern `VAR=N command` (ไม่มี `;`) ที่ใช้ใน `--auto`/`--autonoroot`/`--all`/`--missing`/`--root` ให้เป็น `VAR=N; command` ให้สม่ำเสมอกับที่อื่นในไฟล์
- เพิ่ม comment กำกับจุดที่ตั้งใจ `chmod 777` (โฟลเดอร์ lab ของคอร์ส PBB/PEH ที่ตั้งใจให้ vulnerable เพื่อสอน) กันคนงงว่าเป็นบั๊ก
- เปิดเผยปุ่มลับ `^`/`install_everything` ในเมนูที่พิมพ์ออกมาและใน `--help` (เดิมใช้งานได้จริงแต่ไม่โชว์ที่ไหนเลย) พร้อมเพิ่ม flag `--everything` ให้ตรงกับปุ่มเมนูอื่น ๆ
- แก้คำอธิบายเมนู `0` จาก "Fix ONLY 1 thru 8" (ผิด เพราะจริง ๆ รัน `fix_missing` ที่มีกว่า 50 รายการ) เป็นคำอธิบายที่ตรงกับพฤติกรรมจริง
- Rebrand ข้อความที่ยังเรียกตัวเองว่า "pimpmykali"/"pimpmykali.sh" ให้เป็น "banzeimykali" (log filename, error/exit message, ชื่อฟังก์ชันเมนู/help, ข้อความในเมนู) ส่วนการอ้างอิง credit/URL ไปยัง upstream `Dewalt-arch/pimpmykali` ยังคงไว้ตามจริง

## Disclaimer

ใช้ความเสี่ยงของผู้ใช้เอง ผู้พัฒนา/ผู้ดูแลไม่รับผิดต่อความเสียหายใด ๆ ที่เกิดจากการใช้สคริปต์นี้
แนะนำให้ทดสอบใน VM/แล็บก่อนใช้กับเครื่องจริงหรือเครื่องที่ใช้ในการทำงานจริง

## Credits

- [Dewalt-arch/pimpmykali](https://github.com/Dewalt-arch/pimpmykali) — ต้นฉบับของสคริปต์นี้
- H1r0t0 — ผู้ปรับแต่ง/ดูแล banzeimykali
