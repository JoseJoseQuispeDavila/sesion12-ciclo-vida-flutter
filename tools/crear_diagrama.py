"""Genera el diagrama entregable de la Sesión 12."""

from math import atan2, cos, sin, pi
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
OUTPUT = ROOT / "diagrama_ciclo_vida.png"
WIDTH, HEIGHT = 1800, 1640

INK = "#17223B"
MUTED = "#53627B"
BLUE = "#2E56C1"
GREEN = "#137C66"
ORANGE = "#C46A20"
RED = "#B83F4B"
BG = "#F7F9FC"

font_dir = Path("C:/Windows/Fonts")
font_regular = font_dir / "segoeui.ttf"
font_bold = font_dir / "segoeuib.ttf"


def font(size, bold=False):
    path = font_bold if bold else font_regular
    return ImageFont.truetype(str(path), size)


image = Image.new("RGB", (WIDTH, HEIGHT), BG)
draw = ImageDraw.Draw(image)


def centered(text, x, y, chosen_font, color=INK):
    bounds = draw.textbbox((0, 0), text, font=chosen_font)
    draw.text((x - (bounds[2] - bounds[0]) / 2, y), text, font=chosen_font, fill=color)


def box(rect, title, subtitle, fill, outline):
    draw.rounded_rectangle(rect, radius=22, fill=fill, outline=outline, width=3)
    x1, y1, x2, _ = rect
    centered(title, (x1 + x2) / 2, y1 + 14, font(27, True))
    centered(subtitle, (x1 + x2) / 2, y1 + 55, font(20), MUTED)


def arrow(points, color=BLUE, width=5):
    draw.line(points, fill=color, width=width, joint="curve")
    x0, y0 = points[-2]
    x1, y1 = points[-1]
    angle = atan2(y1 - y0, x1 - x0)
    length = 18
    left = (
        x1 - length * cos(angle - pi / 6),
        y1 - length * sin(angle - pi / 6),
    )
    right = (
        x1 - length * cos(angle + pi / 6),
        y1 - length * sin(angle + pi / 6),
    )
    draw.polygon([(x1, y1), left, right], fill=color)


def tag(text, x, y, color=MUTED):
    draw.text((x, y), text, font=font(18, True), fill=color)


centered("Ciclo de vida de un StatefulWidget", WIDTH / 2, 32, font(43, True))
centered("Sesión 12 · SensorCicloVida · rutas principales y condicionales", WIDTH / 2, 90, font(23), MUTED)

box((120, 165, 650, 250), "Constructor del widget", "Configuración inmutable: versión", "#FFFFFF", "#CBD4E5")
box((120, 290, 650, 385), "createState()", "Una vez · crea el objeto State", "#E8EEFF", BLUE)
box((120, 425, 650, 510), "mounted = true", "State asociado al BuildContext", "#E3F5EF", GREEN)
box((120, 550, 650, 645), "initState()", "Una vez · inicializar variables", "#E8EEFF", BLUE)
box((120, 685, 650, 780), "didChangeDependencies()", "Inicial y al cambiar Theme", "#E8EEFF", BLUE)
box((120, 825, 650, 920), "build()", "Repetible · dibujar la interfaz", "#E8EEFF", BLUE)
box((120, 1090, 650, 1185), "deactivate()", "Al retirar el widget del árbol", "#FFF0DF", ORANGE)
box((120, 1360, 650, 1455), "dispose()", "Una vez · liberar recursos", "#FFE9EB", RED)
box((120, 1490, 650, 1585), "mounted = false", "Ya no se puede llamar a setState()", "#FFE9EB", RED)

for start, end in [
    ((385, 250), (385, 290)),
    ((385, 385), (385, 425)),
    ((385, 510), (385, 550)),
    ((385, 645), (385, 685)),
    ((385, 780), (385, 825)),
    ((385, 920), (385, 1090)),
    ((385, 1185), (385, 1360)),
    ((385, 1455), (385, 1490)),
]:
    arrow([start, end])

tag("Si se retira", 405, 990)
tag("Si NO se reinserta", 405, 1250, RED)

box((925, 685, 1635, 780), "Cambia una dependencia", "Theme.of(context) → didChangeDependencies()", "#E3F5EF", GREEN)
arrow([(925, 733), (650, 733)], GREEN)

box((925, 825, 1635, 920), "Evento → setState()", "Actualiza el contador; regresa a build()", "#E3F5EF", GREEN)
arrow([(925, 872), (650, 872)], GREEN)

box((925, 975, 1635, 1060), "El padre envía otra instancia", "Mismo tipo y misma posición en el árbol", "#FFF0DF", ORANGE)
box((925, 1100, 1635, 1195), "didUpdateWidget(oldWidget)", "Condicional · comparar versión anterior", "#FFF0DF", ORANGE)
arrow([(1280, 1060), (1280, 1100)], ORANGE)
arrow([(925, 1148), (795, 1148), (795, 872), (650, 872)], ORANGE)

tag("No vuelve a initState()", 1015, 940, GREEN)
tag("Ejemplo: botón 'Actualizar desde el padre'", 990, 1210, ORANGE)

image.save(OUTPUT, optimize=True)
print(OUTPUT)
