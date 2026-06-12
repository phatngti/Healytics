const healyticsConfig = {
  demo: {
    previewUrl: "https://drive.google.com/file/d/1DqM6ewntBPVNJPPJDmvPD0L0YFKIORUa/preview",
    viewUrl: "https://drive.google.com/file/d/1DqM6ewntBPVNJPPJDmvPD0L0YFKIORUa/view?usp=sharing",
  },
  downloads: {
    user: "https://drive.google.com/uc?export=download&id=1hiifjYZ7ShyYb5mCG8ogsI3ve-lfRoYZ",
    partner: "https://drive.google.com/uc?export=download&id=1AbvqOX_h1fkn79F6H9Xv6Pw4_8sXnxPd",
  },
};

const header = document.querySelector("[data-header]");
const nav = document.querySelector("[data-nav]");
const navToggle = document.querySelector("[data-nav-toggle]");
const demoFrame = document.querySelector("[data-demo-frame]");
const demoLink = document.querySelector("[data-demo-link]");
const fallback = document.querySelector("[data-video-fallback]");

if (demoFrame) {
  demoFrame.src = healyticsConfig.demo.previewUrl;
}

if (demoLink) {
  demoLink.href = healyticsConfig.demo.viewUrl;
}

document.querySelectorAll("[data-download]").forEach((link) => {
  const key = link.dataset.download;
  if (healyticsConfig.downloads[key]) {
    link.href = healyticsConfig.downloads[key];
  }
});

navToggle?.addEventListener("click", () => {
  const isOpen = nav?.classList.toggle("open") ?? false;
  navToggle.setAttribute("aria-expanded", String(isOpen));
});

nav?.querySelectorAll("a").forEach((link) => {
  link.addEventListener("click", () => {
    nav.classList.remove("open");
    navToggle?.setAttribute("aria-expanded", "false");
  });
});

const updateHeader = () => {
  header?.classList.toggle("scrolled", window.scrollY > 12);
};

updateHeader();
window.addEventListener("scroll", updateHeader, { passive: true });

const revealObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("visible");
        revealObserver.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.14 },
);

document.querySelectorAll(".reveal").forEach((element) => revealObserver.observe(element));

const sectionLinks = Array.from(document.querySelectorAll(".site-nav a"));
const sectionTargets = sectionLinks
  .map((link) => document.querySelector(link.getAttribute("href")))
  .filter(Boolean);

const activeObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return;
      sectionLinks.forEach((link) => {
        link.classList.toggle("active", link.getAttribute("href") === `#${entry.target.id}`);
      });
    });
  },
  {
    rootMargin: "-42% 0px -48% 0px",
    threshold: 0,
  },
);

sectionTargets.forEach((section) => activeObserver.observe(section));

if (fallback) {
  window.setTimeout(() => {
    fallback.classList.add("visible");
  }, 1600);
}
