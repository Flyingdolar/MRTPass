<template>
  <n-card class="card">
    <n-space size="large" line-height="20px">
      <n-button @click="goback" size="large" justify="start">返回</n-button>
      <n-h3 class="cardtitle" text-align="center">編輯站點</n-h3>
      <n-space>
        <n-tabs type="line" animated>
          <n-tab-pane name="基本資訊" tab="基本資訊">
            <n-space justify="center" class="content2">
              <n-card
                :bordered="false"
                size="huge"
                role="dialog"
                aria-modal="true"
              >
                <n-form ref="formRef" :label-width="80">
                  <n-form-item label="站點名稱"
                    ><n-input v-model:value="model.name"></n-input
                  ></n-form-item>
                  <n-form-item label="所屬路線"
                    ><n-select
                      v-model:value="model.linecolor"
                      :options="lineOptions"
                    ></n-select
                  ></n-form-item>
                  <n-form-item label="所屬路線編號"
                    ><n-input v-model:value="model.number"></n-input
                  ></n-form-item>
                  <n-form-item label="交叉路線"
                    ><n-select
                      v-model:value="model.linecolor2"
                      :options="lineOptions"
                    ></n-select
                  ></n-form-item>
                  <n-form-item label="交叉路線編號"
                    ><n-input v-model:value="model.number2"></n-input
                  ></n-form-item>
                  <n-form-item label="經度"
                    ><n-input v-model:value="model.y_Pos"></n-input
                  ></n-form-item>
                  <n-form-item label="緯度"
                    ><n-input v-model:value="model.x_Pos"></n-input
                  ></n-form-item>
                  <n-form-item label="站點出口數"
                    ><n-input v-model:value="model.exit_Num"></n-input
                  ></n-form-item>
                </n-form>
                <template #footer>
                  <n-space vertical>
                    <n-button @click="SaveEdit">儲存</n-button>
                  </n-space>
                </template>
              </n-card>
            </n-space>
          </n-tab-pane>
          <n-tab-pane name="班次列表" tab="班次列表">
            <n-space>
              <n-card
                ><div
                  v-for="(item, index) in filteredItems(currentindex)"
                  :key="item.timetable.id"
                >
                  <n-card>
                    <n-space align="start" size="large" w="full">
                      <n-h3
                        >{{ item.line }}/往{{ item.to }}
                        {{ item.timetable.time }}
                        {{ item.timetable.No.toString() }}</n-h3
                      >
                      <n-space align="end" size="large">
                        <n-button @click="EditTimeTable(item.timetable)"
                          >編輯</n-button
                        >
                        <n-modal v-model:show="editTimeTablemodal">
                          <n-space justify="center" class="content2">
                            <n-card
                              :bordered="false"
                              size="huge"
                              role="dialog"
                              aria-modal="true"
                            >
                              <n-form ref="formRef" :label-width="80">
                                <n-form-item label="所屬路線"
                                  ><n-select
                                    v-model:value="CurrentRoute"
                                    :options="lineOptions2"
                                  ></n-select
                                ></n-form-item>
                                <n-form-item label="班次目的地"
                                  ><n-select
                                    v-model:value="CurrentStation"
                                    :options="stationOpt"
                                    placeholder="請選擇站點"
                                /></n-form-item>
                                <n-form-item label="車次"
                                  ><n-input
                                    v-model:value="model.Mrtno"
                                  ></n-input
                                ></n-form-item>
                                <n-form-item label="到站時間">
                                  <n-time-picker
                                    v-model:formatted-value="model.deptime"
                                    value-format="H~m~s"
                                    :actions="['confirm']"
                                  />
                                </n-form-item>
                              </n-form>
                              <template #footer>
                                <n-space vertical>
                                  <n-button @click="SaveTimeTableEdit"
                                    >儲存</n-button
                                  >
                                </n-space>
                              </template>
                            </n-card>
                          </n-space>
                        </n-modal>
                        <n-popconfirm
                          @positive-click="
                            DeleteStation(item.timetable.id, index)
                          "
                          ><template #trigger
                            ><n-button>刪除</n-button></template
                          >確認刪除</n-popconfirm
                        >
                      </n-space>
                    </n-space>
                  </n-card>
                </div>
                <n-button
                  @click="currentindex -= 20"
                  :disabled="checkminvalue()"
                  >上20筆資料</n-button
                >
                <n-button
                  @click="currentindex += 20"
                  :disabled="checkmaxvalue()"
                  >下20筆資料</n-button
                >
              </n-card>
            </n-space>
          </n-tab-pane>
        </n-tabs>
      </n-space>
    </n-space>
  </n-card>
</template>

<script setup lang="ts">
import {
  NCard,
  NSpace,
  NButton,
  NModal,
  NDataTable,
  useMessage,
  NH3,
  NForm,
  NFormItem,
  NInput,
  NSelect,
  NPopconfirm,
  NTabs,
  NTabPane,
  NTimePicker,
} from "naive-ui";
import type { DataTableColumns } from "naive-ui";
import {
  computed,
  h,
  onMounted,
  ref,
  watch,
  reactive,
  onBeforeMount,
} from "vue";
import { watchOnce } from "@vueuse/core";
import {
  Station,
  Role,
  Line,
  TimeTable,
  AlotsTimeTable,
  LineStation,
} from "../scripts/types";
import axios from "axios";
import router from "@/router";
import { useRoute } from "vue-router";
const message = useMessage();
const editTimeTablemodal = ref(false);
const route = useRoute();
const model = reactive({
  exit_Num: 0,
  id: 0,
  name: "",
  x_Pos: 0,
  y_Pos: 0,
  number: 0,
  linecolor: "",
  linename: "",
  number2: "",
  linecolor2: "",
  linename2: "",
  deptime: ref("0~0~0"),
  Mrtno: "",
});
const AllLine = ref<Line[]>();
const AllLine2 = ref<Line[]>();
const AllTimeTable = ref<AlotsTimeTable[]>();
const currentindex = ref(0);
onBeforeMount(() => {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/station/" + route.params.id)
    .then(function (response) {
      //message.info(response.data.message);
      //console.log(response.data.data);
      //console.log(response.data.data.stationno);
      model.exit_Num = response.data.data.station.exit_Num;
      model.id = response.data.data.station.id;
      model.name = response.data.data.station.name;
      model.x_Pos = response.data.data.station.x_Pos;
      model.y_Pos = response.data.data.station.y_Pos;
      model.number = response.data.data.stationno[0].stationno.number;
      model.linecolor = response.data.data.stationno[0].stationno.linecolor;
      model.linename = response.data.data.stationno[0].linename;
      if (response.data.data.stationno.length == 2) {
        model.number2 = response.data.data.stationno[1].stationno.number;
        model.linecolor2 = response.data.data.stationno[1].stationno.linecolor;
        model.linename2 = response.data.data.stationno[1].linename;
      }
      //console.log(model);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line")
    .then(function (response) {
      //console.log(response.data.data);
      AllLine.value = response.data.data;
      //console.log(AllLine.value);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
  axios
    .get(
      "http://localhost:3000/api/mrt_admin/station/" + route.params.id + "/line"
    )
    .then(function (response) {
      //console.log(response.data.data);
      AllLine2.value = response.data.data;
      //console.log(AllLine.value);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
  //axios get
  axios
    .get(
      "http://localhost:3000/api/mrt_admin/station/" +
        route.params.id +
        "/time_table"
    )
    .then(function (response) {
      console.log(response.data.data);
      AllTimeTable.value = response.data.data;
      //console.log("done");
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
});
const lineOptions = computed(() =>
  AllLine.value?.map((v, index) => ({
    label: v.linecolor + v.name,
    value: v.linecolor,
  }))
);
const lineOptions2 = computed(() =>
  AllLine2.value?.map((v, index) => ({
    label: v.linecolor + v.name,
    value: v.linecolor,
  }))
);
function goback() {
  router.push("/stationlist");
}
function SaveEdit() {
  //axios patch
  axios
    .patch("http://localhost:3000/api/mrt_admin/station/" + route.params.id, {
      name: model.name,
      linecolor_1: model.linecolor,
      number_1: model.number,
      x_Pos: model.x_Pos,
      y_Pos: model.y_Pos,
      linecolor_2: model.linecolor2,
      number_2: model.number2,
      exit_Num: model.exit_Num,
    })
    .then(function (response) {
      message.info(response.data.message);
      router.push("/stationlist");
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
function EditStation(id: number) {
  console.log("wait");
}
function DeleteStation(id: number, index: number) {
  //axios delete
  axios
    .delete(
      "http://localhost:3000/api/mrt_admin/station/" +
        route.params.id +
        "/time_table/" +
        (id as unknown as string)
    )
    .then(function (response) {
      console.log(response);
      AllTimeTable.value?.splice(index, 1);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
const editing = ref(0);
function EditTimeTable(item: TimeTable) {
  editTimeTablemodal.value = !editTimeTablemodal.value;
  model.Mrtno = item.No.toString();
  CurrentRoute.value = item.line;
  editing.value = item.id;
}
function filteredItems(index: number) {
  const retItems = AllTimeTable.value?.slice(index, index + 20);
  return retItems;
}
function checkmaxvalue() {
  if (currentindex.value + 20 < AllTimeTable.value?.length) {
    return false;
  } else {
    return true;
  }
}
function checkminvalue() {
  if (currentindex.value == 0) {
    return true;
  } else {
    return false;
  }
}
function formatNumber(number: number) {
  return number < 10 ? "0" + number : number.toString();
}
function SaveTimeTableEdit() {
  console.log(CurrentStation.value);
  //console.log(model.deptime.split("~")[0] + ":" + model.deptime.split("~")[1]);
  const depH = computed(() => {
    const number = parseInt(model.deptime.split("~")[0]);
    return formatNumber(number);
  });
  const depM = computed(() => {
    const number = parseInt(model.deptime.split("~")[1]);
    return formatNumber(number);
  });
  console.log(depH.value + ":" + depM.value);
  //axios patch
  axios
    .patch(
      "http://localhost:3000/api/mrt_admin/station/" +
        route.params.id +
        "/time_table/" +
        editing.value.toString(),
      {
        time: depH.value + ":" + depM.value,
        No: parseInt(model.Mrtno),
        line: CurrentRoute.value,
        end: CurrentStation.value,
      }
    )
    .then(function (response) {
      console.log(response);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
const CurrentLineStation = ref<LineStation[]>();
const CurrentRoute = ref<string>();
const CurrentStation = ref<number | null>();
const stationOpt = computed(() =>
  CurrentLineStation.value?.map((v, index) => ({
    label: v.station.name,
    value: v.station.id,
  }))
);
watch(CurrentRoute, (CurrentRoute) => {
  CurrentStation.value = null;
  //console.log(CurrentRoute);
  updateStationOpt();
});
function updateStationOpt() {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/line_station", {
      params: {
        linecolor: CurrentRoute.value,
      },
    })
    .then(function (response) {
      //console.log(response);
      CurrentLineStation.value = response.data.data;
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
</script>
