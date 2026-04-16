#!/usr/bin/env python3
"""
ROS2 Launch file for UAV Inspection Simulation
启动Gazebo仿真世界并配置环境
"""

import os
from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch.actions import ExecuteProcess, DeclareLaunchArgument, SetEnvironmentVariable
from launch.substitutions import LaunchConfiguration
from launch_ros.actions import Node


def generate_launch_description():
    # Get package directory
    pkg_dir = get_package_share_directory('uav_inspection')
    worlds_dir = os.path.join(pkg_dir, 'worlds')

    # World file path
    world_file = os.path.join(worlds_dir, 'inspection_world.sdf')

    # Set Gazebo resource path
    gz_resource_path = SetEnvironmentVariable(
        'GZ_SIM_RESOURCE_PATH',
        worlds_dir + ':' + os.environ.get('GZ_SIM_RESOURCE_PATH', '')
    )

    # Declare launch arguments
    world_arg = DeclareLaunchArgument(
        'world',
        default_value=world_file,
        description='Path to the Gazebo world SDF file'
    )

    verbose_arg = DeclareLaunchArgument(
        'verbose',
        default_value='3',
        description='Gazebo verbosity level'
    )

    # Start Gazebo server
    gz_server = ExecuteProcess(
        cmd=['gz', 'sim', '-v', LaunchConfiguration('verbose'), '-s', LaunchConfiguration('world')],
        output='screen',
    )

    # Start Gazebo client (GUI)
    gz_client = ExecuteProcess(
        cmd=['gz', 'sim', '-g'],
        output='screen',
    )

    return LaunchDescription([
        gz_resource_path,
        world_arg,
        verbose_arg,
        # gz_server,
        # gz_client,
        # Note: Commented out to allow manual control
        # Users can uncomment these to auto-start Gazebo
    ])