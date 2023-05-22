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
        path: "MRTInfo",
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
];

const router = createRouter({
  history: createWebHashHistory(),
  routes,
});
const commonRoute = ["home", "profile"];
const applicantRoute = ["ApplyForm"];
const reviewerRoute = ["AssignedWork", "ReviewMain", "ReviewDoc", "ReviewOral"];
const pmRoute = ["Dashboard"];
const adminRoute = ["SysMain", "SysUser"];
const notLoginRoute = ["myaccount", "about", "viewpost", "home"];

router.beforeEach(async (to) => {
  const isLogin = store.state.isLogin;
  if (isLogin) {
    const role = store.state.role;
    if (to.name === "Login" || to.name === "Register") {
      return { name: "Home" };
    }
    if (commonRoute.includes(to.name as string)) {
      return true;
    } else if (role === "APPLICANT") {
      if (!applicantRoute.includes(to.name as string)) {
        return { name: "Home" };
      }
    } else if (role === "REVIEWER") {
      if (!reviewerRoute.includes(to.name as string)) {
        return { name: "Home" };
      }
    } else if (role === "PROGRAMMANAGER") {
      if (!pmRoute.includes(to.name as string)) {
        return { name: "Home" };
      }
    } else if (role === "ADMIN") {
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
