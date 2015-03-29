BeginPackage["mathMutable`"]

mathMutable::usage =
    "Allow references to values that change over time."

createMutable::usage =
    "Create a reference to an memory managed object whose value can change over time."

mutable::usage =
    "Head for mutable object references."

Begin["`Private`"]

SetAttributes[applyMutable, HoldAll]

applyMutable[Null, state_, Null] :=
    state

applyMutable[List, state_, value_] :=
    state = value[[1]]

applyMutable[List, state_, value_, partSpec__] :=
    state[[partSpec]] = value[[1]]

applyMutable[Association, state_, value_, key_] :=
    state[key] = value[[1]]

createMutable[value_] :=
    Module[{state},
        state = value;
        mutable[
            Function[{type, newValue, partSpec},
                applyMutable[type, state, newValue, Evaluate[Sequence@@partSpec]]
            ]
        ]
    ]

Unprotect[Set]

Set[object_, value_] :=
    Module[{mutableObject, partSpec},
        {mutableObject, partSpec} =
            Hold[object] /. Hold[Part[m_, spec__]] :> {m, {spec}};
        mutableObject[[1]][List, {value}, partSpec]
    ] /; MatchQ[Hold[object], Hold[Part[symbol_Symbol, __]] /;
           MatchQ[OwnValues[symbol], {_ :> mutable[_], ___}]
        ]

Set[object_, value_] :=
    Module[{mutableFunction},
        object[[1]][List, {value}, {}]
    ] /; MatchQ[Hold[object], Hold[symbol_Symbol] /;
           MatchQ[OwnValues[symbol], {_ :> mutable[_], ___}]
        ]

Set[object_, value_] :=
    Module[{mutableFunction},
        object[[0, 1]][Association, {value}, object[[1]]]
    ] /; MatchQ[Hold[object], Hold[symbol_Symbol[_]] /;
           MatchQ[OwnValues[symbol], {_ :> mutable[_], ___}]
        ]

Set[mutable[f_], value_] :=
    f[List, {value}, {}]

Set[Part[mutable[f_], partSpec__], value_] :=
    f[List, {value}, {partSpec}]

Set[mutable[f_][key_], value_] :=
    f[Association, {value}, {key}]

Protect[Set]

mutable[mutableFunction_][] :=
    mutableFunction[Null, Null, {}]

End[ ]

EndPackage[ ]