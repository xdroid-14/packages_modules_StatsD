# Copyright (C) 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH:= $(call my-dir)

statsd_common_src := \
    ../../core/java/android/os/IStatsCompanionService.aidl \
    ../../core/java/android/os/IStatsManager.aidl \
    src/stats_log.proto \
    src/statsd_config.proto \
    src/statsd_internal.proto \
    src/atoms.proto \
    src/field_util.cpp \
    src/stats_log_util.cpp \
    src/dimension.cpp \
    src/anomaly/AnomalyMonitor.cpp \
    src/anomaly/AnomalyTracker.cpp \
    src/anomaly/DurationAnomalyTracker.cpp \
    src/condition/CombinationConditionTracker.cpp \
    src/condition/condition_util.cpp \
    src/condition/SimpleConditionTracker.cpp \
    src/condition/ConditionWizard.cpp \
    src/config/ConfigKey.cpp \
    src/config/ConfigListener.cpp \
    src/config/ConfigManager.cpp \
    src/external/Perfetto.cpp \
    src/external/StatsPuller.cpp \
    src/external/StatsCompanionServicePuller.cpp \
    src/external/SubsystemSleepStatePuller.cpp \
    src/external/CpuTimePerUidPuller.cpp \
    src/external/CpuTimePerUidFreqPuller.cpp \
    src/external/StatsPullerManagerImpl.cpp \
    src/logd/LogEvent.cpp \
    src/logd/LogListener.cpp \
    src/logd/LogReader.cpp \
    src/matchers/CombinationLogMatchingTracker.cpp \
    src/matchers/matcher_util.cpp \
    src/matchers/SimpleLogMatchingTracker.cpp \
    src/metrics/MetricProducer.cpp \
    src/metrics/EventMetricProducer.cpp \
    src/metrics/CountMetricProducer.cpp \
    src/metrics/DurationMetricProducer.cpp \
    src/metrics/duration_helper/OringDurationTracker.cpp \
    src/metrics/duration_helper/MaxDurationTracker.cpp \
    src/metrics/ValueMetricProducer.cpp \
    src/metrics/GaugeMetricProducer.cpp \
    src/metrics/MetricsManager.cpp \
    src/metrics/metrics_manager_util.cpp \
    src/packages/UidMap.cpp \
    src/perfetto/perfetto_config.proto \
    src/storage/StorageManager.cpp \
    src/StatsLogProcessor.cpp \
    src/StatsService.cpp \
    src/HashableDimensionKey.cpp \
    src/guardrail/MemoryLeakTrackUtil.cpp \
    src/guardrail/StatsdStats.cpp

statsd_common_c_includes := \
    $(LOCAL_PATH)/src \
    $(LOCAL_PATH)/../../libs/services/include

statsd_common_aidl_includes := \
    $(LOCAL_PATH)/../../core/java

statsd_common_static_libraries := \
    libplatformprotos

statsd_common_shared_libraries := \
    libbase \
    libbinder \
    libcutils \
    libincident \
    liblog \
    libselinux \
    libutils \
    libservices \
    libprotoutil \
    libstatslog \
    libhardware \
    libhardware_legacy \
    libhidlbase \
    libhidltransport \
    libhwbinder \
    android.hardware.power@1.0 \
    android.hardware.power@1.1 \
    libmemunreachable

# =========
# statsd
# =========

include $(CLEAR_VARS)

LOCAL_MODULE := statsd

LOCAL_SRC_FILES := \
    $(statsd_common_src) \
    src/main.cpp

LOCAL_CFLAGS += \
    -Wall \
    -Werror \
    -Wno-missing-field-initializers \
    -Wno-unused-variable \
    -Wno-unused-function \
    -Wno-unused-parameter

ifeq (debug,)
    LOCAL_CFLAGS += \
            -g -O0
else
    # optimize for size (protobuf glop can get big)
    LOCAL_CFLAGS += \
            -Os
endif
LOCAL_PROTOC_OPTIMIZE_TYPE := lite-static

LOCAL_AIDL_INCLUDES := $(statsd_common_aidl_includes)
LOCAL_C_INCLUDES += $(statsd_common_c_includes)

LOCAL_STATIC_LIBRARIES := $(statsd_common_static_libraries)

LOCAL_SHARED_LIBRARIES := $(statsd_common_shared_libraries) \
    libgtest_prod

LOCAL_MODULE_CLASS := EXECUTABLES

#LOCAL_INIT_RC := statsd.rc

include $(BUILD_EXECUTABLE)


# ==============
# statsd_test
# ==============

include $(CLEAR_VARS)

LOCAL_MODULE := statsd_test
LOCAL_COMPATIBILITY_SUITE := device-tests
LOCAL_MODULE_TAGS := tests

LOCAL_AIDL_INCLUDES := $(statsd_common_aidl_includes)
LOCAL_C_INCLUDES += $(statsd_common_c_includes)

LOCAL_CFLAGS += \
    -Wall \
    -Werror \
    -Wno-missing-field-initializers \
    -Wno-unused-variable \
    -Wno-unused-function \
    -Wno-unused-parameter

LOCAL_SRC_FILES := \
    $(statsd_common_src) \
    tests/AnomalyMonitor_test.cpp \
    tests/anomaly/AnomalyTracker_test.cpp \
    tests/ConfigManager_test.cpp \
    tests/indexed_priority_queue_test.cpp \
    tests/LogEntryMatcher_test.cpp \
    tests/LogReader_test.cpp \
    tests/LogEvent_test.cpp \
    tests/MetricsManager_test.cpp \
    tests/StatsLogProcessor_test.cpp \
    tests/UidMap_test.cpp \
    tests/condition/CombinationConditionTracker_test.cpp \
    tests/condition/SimpleConditionTracker_test.cpp \
    tests/metrics/OringDurationTracker_test.cpp \
    tests/metrics/MaxDurationTracker_test.cpp \
    tests/metrics/CountMetricProducer_test.cpp \
    tests/metrics/DurationMetricProducer_test.cpp \
    tests/metrics/EventMetricProducer_test.cpp \
    tests/metrics/ValueMetricProducer_test.cpp \
    tests/metrics/GaugeMetricProducer_test.cpp \
    tests/guardrail/StatsdStats_test.cpp \
    tests/metrics/metrics_test_helper.cpp \
    tests/statsd_test_util.cpp \
    tests/e2e/WakelockDuration_e2e_test.cpp \
    tests/e2e/MetricConditionLink_e2e_test.cpp \
    tests/e2e/Attribution_e2e_test.cpp \
    tests/e2e/GaugeMetric_e2e_test.cpp

LOCAL_STATIC_LIBRARIES := \
    $(statsd_common_static_libraries) \
    libgmock

LOCAL_SHARED_LIBRARIES := $(statsd_common_shared_libraries)

LOCAL_PROTOC_OPTIMIZE_TYPE := lite

include $(BUILD_NATIVE_TEST)

##############################
# stats proto static java lib
##############################

include $(CLEAR_VARS)
LOCAL_MODULE := statsdprotolite

LOCAL_SRC_FILES := \
    src/stats_log.proto \
    src/statsd_config.proto \
    src/perfetto/perfetto_config.proto \
    src/atoms.proto

LOCAL_PROTOC_OPTIMIZE_TYPE := lite

LOCAL_STATIC_JAVA_LIBRARIES := \
    platformprotoslite

include $(BUILD_STATIC_JAVA_LIBRARY)

##############################
# statsd micro benchmark
##############################

include $(CLEAR_VARS)
LOCAL_MODULE := statsd_benchmark

LOCAL_SRC_FILES := $(statsd_common_src) \
                   benchmark/main.cpp \
                   benchmark/hello_world_benchmark.cpp \
                   benchmark/log_event_benchmark.cpp

LOCAL_C_INCLUDES := $(statsd_common_c_includes)

LOCAL_CFLAGS := -Wall \
                -Werror \
                -Wno-unused-parameter \
                -Wno-unused-variable \
                -Wno-unused-function \

# Bug: http://b/29823425 Disable -Wvarargs for Clang update to r271374
LOCAL_CFLAGS += -Wno-varargs

LOCAL_AIDL_INCLUDES := $(statsd_common_aidl_includes)

LOCAL_STATIC_LIBRARIES := \
    $(statsd_common_static_libraries)

LOCAL_SHARED_LIBRARIES := $(statsd_common_shared_libraries) \
    libgtest_prod

LOCAL_PROTOC_OPTIMIZE_TYPE := lite

LOCAL_MODULE_TAGS := eng tests

include $(BUILD_NATIVE_BENCHMARK)


statsd_common_src:=
statsd_common_aidl_includes:=
statsd_common_c_includes:=
statsd_common_static_libraries:=
statsd_common_shared_libraries:=


include $(call all-makefiles-under,$(LOCAL_PATH))
