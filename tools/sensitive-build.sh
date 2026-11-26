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
# 固定签名：把仓库里这把 key 落到 android/，让每次构建的签名一致，
# 这样覆盖安装能保住数据（否则每次 CI 的 debug key 都不一样，只能卸载重装）。
python3 - <<'KS'
import base64, pathlib
ks = pathlib.Path("android/dsh-release.p12")
ks.write_bytes(base64.b64decode("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"))
pathlib.Path("android/key.properties").write_text(
    "storeFile=dsh-release.p12\nstoreType=PKCS12\n"
    "storePassword=dshgo9fea22d72d98\nkeyAlias=dsh\nkeyPassword=dshgo9fea22d72d98\n")
print("signing key ready")
KS

cd app && flutter pub get
flutter build apk --debug --flavor arm64 --target-platform android-arm64 \
  --build-name 1.4.1 --build-number 11260341 \
  --dart-define=DSH_APP_VERSION=1.4.1+11260341
