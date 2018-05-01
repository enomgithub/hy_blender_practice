#!/usr/bin/env hy
;; -*- coding: utf-8 -*-

(import math)
(import sys)

(import bpy)


(defn main []
  (setv start 0)
  (setv end 100)
  (setv n 100)

  (setv (. bpy context scene frame-start) start)
  (setv (. bpy context scene frame-end) end)

  ((. bpy ops object camera-add) :location (, 60 30 70)
                                 :rotation (, 0.3 0.8 1.5))

  (for [x (range n)]
       ((. bpy ops mesh primitive-uv-sphere-add)
        :location (, (* ((. math sin) x) 30)
                     (* ((. math cos) x) 30)
                     x))
       (setv obj (. bpy context scene objects active))
       (setv mat ((. bpy data materials new) "Sphere"))
       (setv (. mat diffuse-color) (, (/ x n) (/ (- n x) n) (/ x n)))
       (setv (. mat use-transparency) True)
       (setv (. mat alpha) 0.4)
       ((. obj data materials append) mat)

       ((. bpy context scene frame-set) start)
       ((. obj keyframe-insert) :data-path "location")

       ((. bpy context scene frame-set) end)
       (setv (. obj location) (, (* ((. math sin) (+ x (. math pi))) 30)
                                 (* ((. math cos) (+ x (. math pi))) 30)
                                 x))
       ((. obj keyframe-insert) :data-path "location"))
  0)
