import {
  createRouter,
  createWebHashHistory,
  RouteRecordRaw,
  Router,
} from "vue-router";
import HomeView from "../views/HomeView.vue";
import store from "../scripts/vuex";
const routes: Array<RouteRecordRaw> = [
  {
    path: "/",
    name: "home",
    component: HomeView,
    children: [
      {
        path: "",
        name: "MRTInfo",
        component: () => import("../views/MRTInfo.vue"),
      },
      {
        path: "MRTAnnounce",
        name: "MRTAnnounce",
        component: () => import("../views/MRTAnnounce.vue"),
      },
    ],
  },
  {
    path: "/about",
    name: "about",
    component: () => import("../views/AboutView.vue"),
  },
  {
    path: "/post",
    name: "viewpost",
    component: () => import("../views/submitPost.vue"),
  },
  {
    path: "/account",
    name: "myaccount",
    component: () => import("../views/account/MyAccount.vue"),
  },
  {
    path: "/profile",
    name: "profile",
    component: () => import("../views/account/MyProfile.vue"),
  },
  {
    path: "/memberlist",
    name: "memberlist",
    component: () => import("../views/MemberList.vue"),
  },
  {
    path: "/memberlist/edit",
    name: "edit",
    component: () => import("../views/MemberEdit.vue"),
  },
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});
const commonRoute = [
  "home",
  "MRTInfo",
  "MRTAnnounce",
  "myaccount",
  "about",
  "viewpost",
  "home",
];
const userRoute = ["profile"];
const mrt_adminRoute = ["profile"];
const adminRoute = ["profile", "memberlist"];
const notLoginRoute = [
  "myaccount",
  "about",
  "viewpost",
  "home",
  "MRTInfo",
  "MRTAnnounce",
];

router.beforeEach(async (to) => {
  const isLogin = store.state.userinfo ? true : false;
  if (isLogin) {
    const role = store.state.userinfo?.role as unknown as string;
    if (to.name === "Login" || to.name === "Register") {
      return { name: "Home" };
    }
    if (commonRoute.includes(to.name as string)) {
      return true;
    } else if (role === "user") {
      if (!userRoute.includes(to.name as string)) {
        return { name: "Home" };
      }
    } else if (role === "mrt_admin") {
      if (!mrt_adminRoute.includes(to.name as string)) {
        return { name: "Home" };
      }
    } else if (role === "admin") {
      if (!adminRoute.includes(to.name as string)) {
        return { name: "Home" };
      }
    }
    return true;
  } else {
    if (!to.name || !notLoginRoute.includes(to.name as string)) {
      return { name: "Login" };
    }
    return true;
  }
});

export default router;
