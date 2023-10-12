module Typography : sig
  open Tyxml.Html

  type children = Html_types.h6_content_fun Tyxml_html.elt list_wrap

  type elt =
    [ `H1
    | `H2
    | `H3
    | `H4
    | `H5
    | `H6
    | `P
    ]

  type size =
    [ `Small
    | `Medium
    | `Large
    ]

  type font_style =
    [ `Sans
    | `Serif
    | `Mono
    ]

  type font_weight =
    [ `Thin
    | `ExtraLight
    | `Light
    | `Normal
    | `Medium
    | `SemiBold
    | `Bold
    | `ExtraBold
    | `Black
    ]

  val make
    :  ?classes:string list
    -> ?as_elt:elt
    -> ?size:size
    -> ?font_style:font_style
    -> ?font_weight:font_weight
    -> children:children
    -> unit
    -> elt Tyxml_html.elt
end