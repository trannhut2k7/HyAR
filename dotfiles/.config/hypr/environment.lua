-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Tắt con trỏ phần cứng bằng Lua



-- Cú pháp Lua thuần (chạy trực tiếp lệnh export của Linux)
os.execute("export XMODIFIERS=@im=fcitx")
os.execute("export QT_IM_MODULE=fcitx")
os.execute("export GTK_IM_MODULE=fcitx")
os.execute("export SDL_IM_MODULE=fcitx")
os.execute("export GLFW_IM_MODULE=ibus")