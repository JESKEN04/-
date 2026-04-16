#!/usr/bin/env bash
# ============================================================
# cleanup_logs.sh
# 清理PX4仿真日志文件和校准参数
# ============================================================

echo "清理PX4仿真日志..."

# 清理调试日志
rm -f /tmp/px4_uav*.log /tmp/gazebo.log /tmp/microxrce.log 2>/dev/null
echo "  ✓ 已清理 /tmp 调试日志"

# 清理PX4飞行日志
PX4_DIR="${PX4_DIR:-$HOME/PX4-Autopilot}"
rm -rf "$PX4_DIR/build/px4_sitl_default/rootfs/1/log/"* 2>/dev/null
rm -rf "$PX4_DIR/build/px4_sitl_default/rootfs/2/log/"* 2>/dev/null
rm -rf "$PX4_DIR/build/px4_sitl_default/rootfs/3/log/"* 2>/dev/null
echo "  ✓ 已清理 PX4 飞行日志"

# 可选：清理校准参数（解决磁场校准问题）
if [ "$1" = "--reset-params" ]; then
    echo ""
    echo "重置PX4校准参数..."
    rm -f "$PX4_DIR/build/px4_sitl_default/rootfs/1/parameters.bson" 2>/dev/null
    rm -f "$PX4_DIR/build/px4_sitl_default/rootfs/2/parameters.bson" 2>/dev/null
    rm -f "$PX4_DIR/build/px4_sitl_default/rootfs/3/parameters.bson" 2>/dev/null
    rm -f "$PX4_DIR/build/px4_sitl_default/rootfs/parameters.bson" 2>/dev/null
    echo "  ✓ 已清理校准参数文件"
    echo "  提示: 下次启动PX4时会自动重新校准传感器"
fi

echo ""
echo "日志清理完成！"
echo ""
echo "提示: 如需重置传感器校准参数，请运行: ./cleanup_logs.sh --reset-params"
