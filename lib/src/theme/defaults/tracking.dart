/// Letter spacing scale for `tracking-*`, in em: a multiple of the font size
/// of the text it applies to, exactly Tailwind's scale. `tracking-tight` on
/// 14px text is `14 * -0.025 = -0.35` logical pixels.
const Map<String, double> tracking = {
  'tighter': -0.05,
  'tight': -0.025,
  'normal': 0,
  'wide': 0.025,
  'wider': 0.05,
  'widest': 0.1,
};
