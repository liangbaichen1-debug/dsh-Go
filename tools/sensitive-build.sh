#!/bin/bash
set -eu
U=https://github.com/ccch1mneyyy/dsh-Go/releases/download/v1.4.0
curl -fLs -o /tmp/o.apk $U/dsh-go-1.4.0-arm64.apk
python3 - <<'PY'
import zipfile as Z,os
m=lambda d:os.makedirs(d,exist_ok=True)
z=Z.ZipFile('/tmp/o.apk');A='runtime/out/arm64-v8a/assets/';J='runtime/out/arm64-v8a/jniLibs/arm64-v8a/'
m(A);m(J)
for i in z.infolist():
 n=i.filename
 if n.startswith('assets/') and 'flutter_assets' not in n and not n.endswith('/'):
  p=A+n[7:];m(os.path.dirname(p));open(p,'wb').write(z.read(n))
for b in "libproot.so libproot-loader.so libtalloc.so libandroid-shmem.so libtawcroot.so".split():
 try:open(J+b,'wb').write(z.read('lib/arm64-v8a/'+b))
 except:0
P='app/assets/companion/stage.js';s=open(P,encoding='utf-8').read()
T=[('ear','shy','tilt'),('chest','surprised','recoil'),('belly','shy','duck'),('hip','surprised','tilt'),('groin','surprised','recoil'),('thigh','confused','duck'),('knee','confused','tilt'),('shin','confused','tilt'),('foot','surprised','recoil'),('hand','shy','nodSmall'),('arm','calm','nodSmall')]
a="    legs: { emotion: 'confused', hold: 1500, action: 'tilt' },\n  };"
b=a[:-4]+''.join("    %s: { emotion: '%s', hold: 1500, action: '%s' },\n"%t for t in T)+"  };"
open(P,'w',encoding='utf-8').write(s.replace(a,b))
D='app/lib/ui/companion/companion_page.dart';d=open(D,encoding='utf-8').read()
c="      ('face', _) => '对方刚才戳了戳你的脸',\n      _ => null,"
L=[('ear','耳朵'),('chest','胸口'),('belly','小腹'),('hip','腰'),('groin','两腿之间'),('thigh','大腿'),('knee','膝盖'),('shin','小腿'),('foot','脚'),('hand','手'),('arm','手臂')]
e=c.replace("      _ => null,",''.join("      ('%s', _) => '对方刚才碰了你的%s',\n"%t for t in L)+"      _ => null,")
open(D,'w',encoding='utf-8').write(d.replace(c,e))
PY
python3 tools/zone-split.py
cd app&&flutter pub get
flutter build apk --debug --flavor arm64 --target-platform android-arm64 --build-number 11260340 --dart-define=DSH_APP_VERSION=1.4.0+11260340
