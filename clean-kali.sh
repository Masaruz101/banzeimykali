#!/bin/bash

# --- ตรวจสอบสิทธิ์ Sudo (สำคัญมาก) ---
if [ "$EUID" -ne 0 ]; then 
  echo "❌ กรุณารันสคริปต์นี้ด้วย sudo ครับ"
  echo "   ตัวอย่าง: sudo ./clean-kali.sh"
  exit 1
fi

# --- 1. ฟังก์ชันสำหรับล้างเครื่องแบบธรรมดา ---
run_normal_clean() {
  echo "------------------------------------"
  echo "🚀 เริ่มกระบวนการทำความสะอาด (แบบธรรมดา)..."
  
  echo "[1/2] 🧹 กำลังล้าง APT cache และลบแพ็คเกจเก่า..."
  apt clean && apt autoremove --purge -y

  echo "[2/2] 🧾 กำลังบีบอัดไฟล์ Log (journalctl) ให้เหลือ 100M..."
  journalctl --vacuum-size=100M

  echo "------------------------------------"
  echo "✅ ล้างเครื่องแบบธรรมดาเสร็จสิ้น!"
}


# --- 2. ฟังก์ชันสำหรับ Zero-out (เพิ่ม Trap ดัก Ctrl+C) ---

# สร้างฟังก์ชันสำหรับจัดการการกด Ctrl+C โดยเฉพาะ
cleanup_on_interrupt() {
  echo # เว้นบรรทัดหลังจาก ^C
  echo "🛑 ... ถูกขัดจังหวะ (Ctrl+C)!"
  echo "กำลังลบ /zero.file ชั่วคราว... (กรุณารอสักครู่)"
  
  # สั่ง sync และ rm ไฟล์ทันที
  sync
  if [ -f "/zero.file" ]; then
      rm /zero.file
      echo "✅ ลบ /zero.file เรียบร้อย"
  else
      echo "ℹ️  ไม่พบ /zero.file"
  fi
  
  echo "------------------------------------"
  echo "⚠️  Zero-Out ถูกขัดจังหวะโดยผู้ใช้!"
  echo "➡️  คุณสามารถ Shutdown VM และ 'Compact' ได้เลย"
  echo "   (อาจจะคืนพื้นที่ได้ไม่เต็มที่เท่าทำจนเสร็จ)"
  
  # ออกจากสคริปต์หลัก
  exit 1
}

run_zero_out() {
  echo "------------------------------------"
  echo "💿 เริ่มกระบวนการ Zero-Out (สำหรับ VMware Compact)..."
  echo "⚠️  ขั้นตอนนี้จะใช้เวลานานมาก!"
  echo "🔥  คุณสามารถกด [Ctrl+C] ได้ทุกเมื่อ เพื่อหยุดและลบไฟล์ทันที"
  echo "(หากเห็น 'No space left on device' คือเรื่องปกติ)"
  
  # --- นี่คือส่วนสำคัญ! ---
  # สั่งให้ 'trap' ดักจับสัญญาณ SIGINT (Ctrl+C) และ SIGTERM
  # แล้วให้ไปเรียกใช้ฟังก์ชัน 'cleanup_on_interrupt'
  trap cleanup_on_interrupt SIGINT SIGTERM

  sync # เคลียร์ buffer ก่อน
  
  # รัน dd เหมือนเดิม (การใช้ || true ของคุณยังคงดีเหมือนเดิม)
  dd if=/dev/zero of=/zero.file bs=4M status=progress || true
  
  # --- ปิดการใช้งาน trap ---
  # ถ้า dd ทำงานเสร็จเอง (ไม่ว่าจะเต็มหรือ Error)
  # เราต้องปิด trap เพื่อไม่ให้มันทำงานตอนสคริปต์ส่วนอื่น
  trap - SIGINT SIGTERM
  
  # ส่วนนี้จะทำงานก็ต่อเมื่อ dd จบกระบวนการ (ไม่ถูก Ctrl+C)
  echo "🔄  dd ทำงานเสร็จสิ้น กำลังลบ /zero.file..."
  sync # เคลียร์ buffer หลังเสร็จ
  rm /zero.file
  
  echo "------------------------------------"
  echo "✅ Zero-Out เสร็จสิ้น!"
  echo "➡️  ขั้นตอนต่อไป: ให้คุณ Shutdown VM นี้"
  echo "    แล้วไปที่ VMware Settings > Hard Disk > 'Compact' ได้เลย"
}


# --- 3. ส่วนแสดงเมนู (User Interactive) ---
clear 
echo "===================================="
echo "  Kali Linux Cleaner Script 🧹"
echo "===================================="
echo "กรุณาเลือกรูปแบบการทำงาน:"
echo
echo "  [1] 🧹 Clean Kali (ธรรมดา)"
echo "      (ล้าง apt, autoremove, journalctl - รวดเร็ว)"
echo
echo "  [2] 💿 Clean Kali + Zero-Out (เต็มรูปแบบ)"
echo "      (ทำข้อ 1 + เขียน Zero-out - ช้ามาก, *กด Ctrl+C เพื่อหยุดได้*)"
echo
read -p "ป้อนตัวเลข (1 หรือ 2) แล้วกด Enter: " user_choice

# --- 4. ส่วนประมวลผลตัวเลือก ---
case "$user_choice" in
  1)
    echo "👉 เลือก: 1 - Clean Kali (ธรรมดา)"
    run_normal_clean
    ;;
    
  2)
    echo "👉 เลือก: 2 - Clean Kali + Zero-Out (เต็มรูปแบบ)"
    run_normal_clean  # รันการล้างแบบธรรมดาก่อน
    run_zero_out      # แล้วค่อยรัน zero-out
    ;;
    
  *)
    echo "❌ ไม่พบตัวเลือก '$user_choice'"
    echo "กรุณารันสคริปต์ใหม่อีกครั้ง และเลือก 1 หรือ 2"
    exit 1
    ;;
esac

echo "✨ All done."