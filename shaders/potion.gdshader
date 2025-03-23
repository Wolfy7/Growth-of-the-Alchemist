shader_type canvas_item;

uniform vec4 liquid_color: source_color = vec4(1.0, 0.0, 0.0, 1.0); // Standard: Rot für Leben
uniform float wave_speed = 1.5; // Geschwindigkeit der Wellenbewegung
uniform float wave_amplitude = 8.0; // Stärke der Wellen
uniform float noise_scale = 4.0; // Größe der Blasenbewegung
uniform float liquid_level : hint_range(0.0, 1.0) = 0.8; // Flüssigkeitsstand (zwischen 0 und 1)

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    vec2 uv = UV;
    uv.y = 1.0 - uv.y; // Flüssigkeit von unten nach oben

    // Wellenbewegung für mehr Dynamik
    uv.y += sin(uv.x * 8.0 + TIME * wave_speed) * (wave_amplitude * 0.01);

    // Blubbernde Noise-Struktur für "lebendige" Flüssigkeit
    float bubble_noise = noise(uv * noise_scale + TIME * 0.5) * 0.05;

    // Flüssigkeits-Level (dynamisch anpassbar)
    float current_level = liquid_level + sin(TIME * 0.3) * 0.02; // Leichte Auf- und Abbewegung

    if (uv.y > current_level + bubble_noise) {
        discard; // Transparenz für den oberen Bereich
    }

    COLOR = vec4(liquid_color.rgb, 1.0);
	COLOR.a = texture(TEXTURE, UV).a;
}