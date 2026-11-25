#!/bin/bash
# 只负责把 runtime 资产取回来并编译；触感与文案已经在源码里，不再做字符串注入。
set -eu
U=https://github.com/ccch1mneyyy/dsh-Go/releases/download/v1.4.0
curl -fLs -o /tmp/o.apk $U/dsh-go-1.4.0-arm64.apk
python3 - <<'PY'
import zipfile as Z, os
m = lambda d: os.makedirs(d, exist_ok=True)
z = Z.ZipFile('/tmp/o.apk')
A = 'runtime/out/arm64-v8a/assets/'
J = 'runtime/out/arm64-v8a/jniLibs/arm64-v8a/'
m(A); m(J)
for i in z.infolist():
    n = i.filename
    if n.startswith('assets/') and 'flutter_assets' not in n and not n.endswith('/'):
        p = A + n[7:]; m(os.path.dirname(p)); open(p, 'wb').write(z.read(n))
for b in "libproot.so libproot-loader.so libtalloc.so libandroid-shmem.so libtawcroot.so".split():
    try: open(J + b, 'wb').write(z.read('lib/arm64-v8a/' + b))
    except Exception: pass
print('runtime assets ready')
PY
cd app && flutter pub get
flutter build apk --debug --flavor arm64 --target-platform android-arm64 \
  --build-name 1.4.1 --build-number 11260341 \
  --dart-define=DSH_APP_VERSION=1.4.1+11260341
