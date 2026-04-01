---
name: android-build-flash
description: Android 项目通用编译和刷入流程
metadata:
  author: ddd-xw
  version: 2.0
---

## Android 项目通用编译和刷入流程

### 编译环境
- 平台：Android 12+，高通平台
- 典型项目：根据实际项目替换路径和脚本名

---

## 一、编译 QSSI（System Image）

### 目录
```bash
cd LA.QSSI.<版本>/LINUX/android
```

### 方法 1：手动编译
```bash
source build/envsetup.sh
lunch <product>-userdebug false row WW EX01
bash build.sh -j8 dist --qssi_only | tee qssi_makelog_$(date +%Y%m%d_%H%M%S).txt
```

### 方法 2：脚本编译
```bash
./buildQSSI.sh userdebug 8 true/false row WW EX01
```

---

## 二、编译 Vendor（Vendor Image）

### 目录
```bash
cd LA.VENDOR.<版本>/LINUX/android
# 或
cd LA.UM.<版本>/LINUX/android
```

### 方法 1：手动编译
```bash
source build/envsetup.sh
lunch <product>-userdebug false row WW EX01
./kernel_platform/build/android/prepare_vendor.sh <product> gki < /dev/null | tee prepare_vendor_$(date +%Y%m%d_%H%M%S).log
bash build.sh -j8 dist --target_only | tee build_vendor_$(date +%Y%m%d_%H%M%S).log
```

### 方法 2：脚本编译
```bash
./buildVENDOR.sh userdebug 8 false/true row WW true EX01
# 或
./buildUM.sh userdebug 8 false
```

---

## 三、合并 QSSI 和 Vendor 镜像

```bash
# 在项目根目录执行
./merge_super_image.sh

# 或生成 release 版本
./merge_release.sh
```

---

## 四、编译 BP（Baseband Processor）

```bash
./build_target_all_<项目>.sh
```

---

## 五、Release 版本

```bash
./release_image_<项目>.sh
```

---

## 编译输出路径

| 文件 | 路径 | 包含内容 |
|------|------|----------|
| boot.img | `out/target/product/<product>/boot.img` | 内核 + 设备树 |
| vendor.img | `out/target/product/<product>/vendor.img` | HAL 层 + vendor 配置 |
| system.img | `out/target/product/qssi/system.img` | Android 系统 |
| super.img | 根目录下 `./merge_super_image.sh` | 合并镜像 |

---

## 刷入方式

### 单文件刷入（推荐）
```bash
# 刷入 boot.img（内核/设备树修改）
fastboot flash boot out/target/product/<product>/boot.img

# 刷入 vendor.img（HAL 修改）
fastboot flash vendor out/target/product/<product>/vendor.img

# 刷入 system.img（系统修改）
fastboot flash system out/target/product/qssi/system.img

# 重启设备
fastboot reboot
```

### 全量刷入
```bash
# 生成 super.img
./merge_super_image.sh

# 刷入所有镜像
fastboot flashall
```

---

## 修改类型对应编译

| 修改类型 | 需要编译 | 需要刷入 |
|----------|----------|----------|
| HAL 层 (hardware/) | `make vendorimage` 或 `./buildVENDOR.sh` | `fastboot flash vendor` |
| 内核驱动 (kernel/) | `make bootimage` 或 `./buildVENDOR.sh` | `fastboot flash boot` |
| 设备树 (devicetree/) | `make bootimage` 或 `./buildVENDOR.sh` | `fastboot flash boot` |
| init.rc 配置 | `make vendorimage` | `fastboot flash vendor` |
| 系统应用 | `make systemimage` 或 `./buildQSSI.sh` | `fastboot flash system` |

---

## 增量编译（修改少时用）

```bash
cd LA.VENDOR.<版本>/LINUX/android
source build/envsetup.sh
lunch <product>-userdebug
make bootimage -j4      # 编译内核+设备树
make vendorimage -j4    # 编译 vendor HAL
```

---

## 常见问题

### 编译失败
```bash
# 清理后重新编译
make clean
make vendorimage -j4
```

### 设备未识别
```bash
# 检查 fastboot 连接
fastboot devices

# 进入 fastboot 模式
adb reboot bootloader
```

---

## 注意事项
1. 增量编译前确保已执行过全量编译
2. 刷入前确认设备已进入 fastboot 模式
3. 刷入后建议清除缓存：`fastboot erase cache`
4. 不同项目的目录名称可能不同，但编译流程基本一致
5. `<product>` 为具体产品名，如 `bengal`、`bengal_515` 等
6. `<版本>` 为实际 SDK 版本号，如 `15.0`、`12.0.r1` 等
7. `<项目>` 为实际项目名称，根据项目替换对应脚本
