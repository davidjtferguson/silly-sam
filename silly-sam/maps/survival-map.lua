return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.2.1",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 50,
  height = 50,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 10,
  nextobjectid = 215,
  properties = {},
  tilesets = {
    {
      name = "test-tileset",
      firstgid = 1,
      filename = "../../map-editing/test-tileset.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 1,
      image = "../assets/art/map/test-tileset-image.png",
      imagewidth = 32,
      imageheight = 64,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 2,
      tiles = {}
    },
    {
      name = "tree-square",
      firstgid = 3,
      filename = "../../map-editing/tree-square-tileset.tsx",
      tilewidth = 353,
      tileheight = 680,
      spacing = 0,
      margin = 0,
      columns = 1,
      image = "../assets/art/environment-textures/tree-square.png",
      imagewidth = 353,
      imageheight = 680,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 353,
        height = 680
      },
      properties = {},
      terrains = {},
      tilecount = 1,
      tiles = {}
    },
    {
      name = "tree-triangle",
      firstgid = 4,
      filename = "../../map-editing/tree-triangle-tileset.tsx",
      tilewidth = 390,
      tileheight = 775,
      spacing = 0,
      margin = 0,
      columns = 1,
      image = "../assets/art/environment-textures/tree-triangle.png",
      imagewidth = 390,
      imageheight = 775,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 390,
        height = 775
      },
      properties = {},
      terrains = {},
      tilecount = 1,
      tiles = {}
    },
    {
      name = "ground-base",
      firstgid = 5,
      filename = "../../map-editing/ground-base.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 17,
      image = "../assets/art/environment-textures/ground-base.png",
      imagewidth = 574,
      imageheight = 566,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 289,
      tiles = {}
    },
    {
      name = "groupedtrees-001",
      firstgid = 294,
      filename = "../../map-editing/groupedtrees-001.tsx",
      tilewidth = 769,
      tileheight = 1221,
      spacing = 0,
      margin = 0,
      columns = 1,
      image = "../assets/art/environment-textures/groupedtrees-001.png",
      imagewidth = 769,
      imageheight = 1221,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 769,
        height = 1221
      },
      properties = {},
      terrains = {},
      tilecount = 1,
      tiles = {}
    },
    {
      name = "groupedtrees-002",
      firstgid = 295,
      filename = "../../map-editing/groupedtrees-002.tsx",
      tilewidth = 735,
      tileheight = 1241,
      spacing = 0,
      margin = 0,
      columns = 1,
      image = "../assets/art/environment-textures/groupedtrees-002.png",
      imagewidth = 735,
      imageheight = 1241,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 735,
        height = 1241
      },
      properties = {},
      terrains = {},
      tilecount = 1,
      tiles = {}
    },
    {
      name = "groupedtrees-003",
      firstgid = 296,
      filename = "../../map-editing/groupedtrees-003.tsx",
      tilewidth = 727,
      tileheight = 1241,
      spacing = 0,
      margin = 0,
      columns = 1,
      image = "../assets/art/environment-textures/groupedtrees-003.png",
      imagewidth = 727,
      imageheight = 1241,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 727,
        height = 1241
      },
      properties = {},
      terrains = {},
      tilecount = 1,
      tiles = {}
    }
  },
  layers = {
    {
      type = "objectgroup",
      id = 8,
      name = "background objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 111,
          name = "",
          type = "",
          shape = "rectangle",
          x = 477.392,
          y = 1035.83,
          width = 196.226,
          height = 378,
          rotation = -2.71126,
          gid = 3,
          visible = true,
          properties = {}
        },
        {
          id = 112,
          name = "",
          type = "",
          shape = "rectangle",
          x = 873.026,
          y = 1014.2,
          width = 225.339,
          height = 414.023,
          rotation = 9.0832,
          gid = 4,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "objectgroup",
      id = 2,
      name = "objects",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      draworder = "topdown",
      properties = {},
      objects = {
        {
          id = 4,
          name = "sam",
          type = "",
          shape = "point",
          x = 760,
          y = 396.97,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 158,
          name = "explodingPlatform",
          type = "",
          shape = "rectangle",
          x = 645,
          y = 995,
          width = 230,
          height = 54.7135,
          rotation = 0,
          visible = true,
          properties = {
            ["static"] = true,
            ["texturePath"] = "assets/art/environment-textures/ground-base.png"
          }
        },
        {
          id = 160,
          name = "explodingPlatform",
          type = "",
          shape = "rectangle",
          x = 415,
          y = 995,
          width = 230,
          height = 54.7135,
          rotation = 0,
          visible = true,
          properties = {
            ["static"] = true,
            ["texturePath"] = "assets/art/environment-textures/ground-base.png"
          }
        },
        {
          id = 161,
          name = "explodingPlatform",
          type = "",
          shape = "rectangle",
          x = 875,
          y = 995,
          width = 230,
          height = 54.7135,
          rotation = 0,
          visible = true,
          properties = {
            ["static"] = true,
            ["texturePath"] = "assets/art/environment-textures/ground-base.png"
          }
        },
        {
          id = 162,
          name = "cameraFocus",
          type = "",
          shape = "point",
          x = 760,
          y = 790,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 1000
          }
        },
        {
          id = 163,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = -41.94,
          y = 1528.48,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 164,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 120.06,
          y = 1518.48,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 165,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 258.06,
          y = 1514.48,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 166,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 370.06,
          y = 1514.48,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 167,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 488.06,
          y = 1498.48,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 168,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 656,
          y = 1494,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 169,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 818,
          y = 1484,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 171,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 969.393,
          y = 1508.78,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 172,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1107.39,
          y = 1504.78,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 173,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1219.39,
          y = 1504.78,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 174,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1337.39,
          y = 1488.78,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 175,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1387.15,
          y = 1660.06,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 176,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1300.67,
          y = 1734.91,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 177,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1844.9,
          y = 1766.12,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 178,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1837.45,
          y = 1598.48,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 179,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1846.42,
          y = 1443.94,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 180,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1867.45,
          y = 1252.18,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 181,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1842.36,
          y = 1089.7,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 182,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1854.36,
          y = 920.002,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 183,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1890.54,
          y = 734.302,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 184,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1581.63,
          y = 1750,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 185,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1574.18,
          y = 1582.36,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 186,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1583.15,
          y = 1427.82,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 187,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1604.18,
          y = 1236.06,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 188,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1579.09,
          y = 1073.58,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 189,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1591.09,
          y = 903.882,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 190,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1627.27,
          y = 718.182,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 191,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 11.5694,
          y = 1672.18,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 193,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 13.0894,
          y = 1350,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 194,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 34.1194,
          y = 1158.24,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 195,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 9.02939,
          y = 995.762,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 196,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 21.0294,
          y = 826.062,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 197,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 57.2094,
          y = 640.362,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 198,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = -251.701,
          y = 1656.06,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 199,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = -259.151,
          y = 1488.42,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 200,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = -250.181,
          y = 1333.88,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 201,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = -229.151,
          y = 1142.12,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 202,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = -254.241,
          y = 979.642,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 203,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = -242.241,
          y = 809.942,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 204,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = -206.061,
          y = 624.242,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 205,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 176.061,
          y = 1693.64,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 206,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 338.061,
          y = 1683.64,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 207,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 476.061,
          y = 1679.64,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 208,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 588.061,
          y = 1679.64,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 209,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 706.061,
          y = 1663.64,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 210,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 809.394,
          y = 1660.3,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 211,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 971.394,
          y = 1650.3,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 212,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1109.39,
          y = 1646.3,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        },
        {
          id = 213,
          name = "changeLevel",
          type = "",
          shape = "point",
          x = 1221.39,
          y = 1646.3,
          width = 0,
          height = 0,
          rotation = 0,
          visible = true,
          properties = {
            ["cameraDistance"] = 100,
            ["newLevelPath"] = "maps/cliff.lua"
          }
        }
      }
    }
  }
}
