open Lwt_result.Syntax
module VoteRoute = Models.Vote.Route

let view ~suggestion_id request =
  let upvote_id = "suggestion-upvote" in
  let* suggestion = Dream.sql request @@ Models.Suggestion.read suggestion_id in
  let* count = Dream.sql request @@ Models.Vote.get_vote_total ~suggestion_id in
  match suggestion with
  | Some suggestion ->
    let open Tyxml.Html in
    let mk_button route name btn =
      button
        ~a:
          [ Hx.post (route ~suggestion_id)
          ; Hx.target (Css ("#" ^ upvote_id))
          ; a_class [ "btn"; btn; "mx-3" ]
          ]
        [ txt name ]
    in
    let row lbl value =
      [ div ~a:[ a_class [ "font-semibold" ] ] [ txt lbl ]; div [ value ] ]
    in
    let rows =
      [ row "Title" (txt suggestion.title)
      ; row
          "Link"
          (a
             ~a:[ a_href suggestion.url; a_class [ "link" ] ]
             [ txt suggestion.url ])
      ; row "Description" (txt suggestion.description)
      ; row
          "Category"
          (suggestion.category |> Models.Suggestion.Category.show |> txt)
      ; row "Upvotes" (span ~a:[ a_id upvote_id ] [ txt (Fmt.str "%d" count) ])
      ]
      |> List.flatten
    in
    Reactagen.Header.html
      suggestion.title
      [ Navbar.nav_elt [ Navbar.nav_item "/" (txt "Home") ]
      ; div
          ~a:[ a_class [ "flex justify-center flex-col max-w-md mx-auto" ] ]
          [ div
              ~a:[ a_class [ "border-2 border-white rounded-lg mt-8" ] ]
              [ div
                  ~a:[ a_class [ "grid grid-cols-[auto,1fr] gap-5 m-3" ] ]
                  rows
              ; div
                  ~a:[ a_class [ "grid grid-cols-1fr gap-4 m-3" ] ]
                  [ mk_button VoteRoute.upvote "Upvote" "btn-success"
                  ; mk_button VoteRoute.downvote "Downvote" "btn-error"
                  ]
              ]
          ]
      ]
    |> Lwt.return_ok
  | None -> Fmt.failwith "Failed to find suggestion: %d" suggestion_id
;;
