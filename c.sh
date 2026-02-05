#!/system/bin/sh

# ================= CONFIGURATION =================
# Target App Package Name
TARGET_PACKAGE="com.dts.freefireth"

# Target File Paths (Add multiple paths inside the quotes, separated by SPACE)
# Maine yahan aapka naya path aur purana path dono add kar diye hain.
TARGET_FILES="/data/user/0/com.dts.freefireth/files/contentcache/Compulsory/android/gameassetbundles/avatar/assetindexer.hCQSj0~2BO12vrK62iO0dUebOzOyU~3D \
/data/user/0/com.dts.freefireth/files/contentcache/Compulsory/android/gameassetbundles/cache_res.lc62SCPCPSdRUwnrGIiNa8Tcc40~3D"
# =================================================

# Root check (mandatory)
if [ "$(id -u)" != "0" ]; then
    echo "Error: Root access required. Run with su."
    exit 1
fi

# 1. Get owner of the app data directory
OWNER=$(stat -c %U /data/data/$TARGET_PACKAGE 2>/dev/null)

# Validate owner
if [ -z "$OWNER" ]; then
    echo "Error: Package name wrong or app not installed."
    exit 1
fi

echo "Detected Owner ID: $OWNER"

# 2. Loop through each file in the list and change owner
for FILE_PATH in $TARGET_FILES; do
    if [ -f "$FILE_PATH" ]; then
        chown "$OWNER:$OWNER" "$FILE_PATH"
        
        # Check result for individual file
        if [ $? -eq 0 ]; then
            echo "Success: Owner changed for $(basename "$FILE_PATH")"
        else
            echo "Error: Failed to change owner for $(basename "$FILE_PATH")"
        fi
    else
        echo "Warning: File not found -> $(basename "$FILE_PATH")"
    fi
done