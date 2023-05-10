<template>
  <div class="about">
    <h1>This is an about page</h1>
    <button @click="goback">Go back</button>
    <button @click="sendout">Sleep</button>
  </div>
</template>

<script setup lang="ts">
import axios from "axios";

function goback() {
  //axios get
  axios
    .get("http://localhost:3000/api/mrt_admin/station")
    .then(function (response) {
      console.log(response);
    });
  //axios
}

function sendout() {
  //axios post
  axios
    .post("http://localhost:3000/api/mrt_admin/station", {
      linecolor: "G",
      number: 5,
      x_Pos: 121.123,
      y_Pos: 23.123,
      Trans_Num: 2,
      exit_Num: 3,
    })
    .then(function (response) {
      console.log(response);
    })
    .catch(function (error) {
      console.log(error);
    });
  //axios
}
</script>
