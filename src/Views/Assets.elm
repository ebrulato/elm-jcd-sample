module Views.Assets exposing (error, flag, spinner, src, url)

{-| Assets, such as images, videos, and audio. (We only have images for now.)
We should never expose asset URLs directly; this module should be in charge of
all of them. One source of truth!
-}

import Html exposing (Attribute, Html)
import Html.Attributes as Attr


type Image
    = Image String



-- IMAGES --


error : Image
error =
    Image "/assets/vacances.jpg"


spinner : Image
spinner =
    Image "assets/spinner.gif"


flag : String -> Image
flag code =
    Image ("assets/png100px/" ++ String.toLower code ++ ".png")



-- USING IMAGES --


src : Image -> Attribute msg
src (Image url) =
    Attr.src url


url : Image -> String
url (Image url) =
    url
