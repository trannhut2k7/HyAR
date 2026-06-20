#!/bin/bash

# ============================================================
#  wallpaper-changer.sh
#  Tự động đổi hình nền Hyprland bằng awww mỗi 0.5 phút
# ============================================================

# --- CẤU HÌNH ---
WALLPAPER_DIR="./picture"   # Thư mục chứa ảnh
INTERVAL=30                                   # Thời gian (giây), 300 = 5 phút
TRANSITION="wipe"                              # Kiểu chuyển cảnh: wipe, fade, left, right, top, bottom, wave, random
TRANSITION_DURATION=1.5                        # Thời gian chuyển cảnh (giây)
TRANSITION_FPS=60                              # FPS animation chuyển cảnh

# --- KIỂM TRA ---
if ! command -v awww &>/dev/null; then
    echo "[ERROR] awww chưa được cài đặt. Hãy cài bằng: paru -S awww"
    exit 1
fi

if [[ ! -d "$WALLPAPER_DIR" ]]; then
    echo "[ERROR] Không tìm thấy thư mục: $WALLPAPER_DIR"
    echo "        Tạo thư mục và thêm ảnh vào, hoặc sửa biến WALLPAPER_DIR trong script."
    exit 1
fi

# Lấy danh sách ảnh hợp lệ
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -maxdepth 2 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \
       -o -iname "*.webp" -o -iname "*.gif" \) | sort)

if [[ ${#WALLPAPERS[@]} -eq 0 ]]; then
    echo "[ERROR] Không có ảnh nào trong $WALLPAPER_DIR"
    exit 1
fi

echo "[INFO] Tìm thấy ${#WALLPAPERS[@]} ảnh trong $WALLPAPER_DIR"
echo "[INFO] Đổi hình nền mỗi ${INTERVAL} giây ($(( INTERVAL / 60 )) phút)"

# --- KHỞI ĐỘNG awww-daemon nếu chưa chạy ---
if ! awww query &>/dev/null; then
    echo "[INFO] Khởi động awww-daemon..."
    awww-daemon &
    sleep 1
fi

# --- HÀM ĐỔI HÌNH NỀN ---
INDEX=0

set_wallpaper() {
    local wall="${WALLPAPERS[$INDEX]}"
    echo "[$(date '+%H:%M:%S')] Đặt hình nền: $(basename "$wall")"

    awww img "$wall" \
        --transition-type "$TRANSITION" \
        --transition-duration "$TRANSITION_DURATION" \
        --transition-fps "$TRANSITION_FPS"

    # Tăng index, quay về đầu khi hết
    INDEX=$(( (INDEX + 1) % ${#WALLPAPERS[@]} ))
}

# Xáo trộn thứ tự ảnh ngẫu nhiên khi bắt đầu
shuffle_wallpapers() {
    local i j tmp
    for (( i=${#WALLPAPERS[@]}-1; i>0; i-- )); do
        j=$(( RANDOM % (i+1) ))
        tmp="${WALLPAPERS[$i]}"
        WALLPAPERS[$i]="${WALLPAPERS[$j]}"
        WALLPAPERS[$j]="$tmp"
    done
}

shuffle_wallpapers

# --- VÒNG LẶP CHÍNH ---
while true; do
    set_wallpaper
    sleep "$INTERVAL"
done