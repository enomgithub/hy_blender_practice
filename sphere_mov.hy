#!/usr/bin/env hy
;; -*- coding: utf-8 -*-

(import math)
(import sys)

(import bpy)


(defn main []
  (setv start 0)
  (setv end 120)
  (setv size 5)
  (setv radius 50)
  (setv n 5)
  (setv theta-max 720)
  (setv theta-step 144)
  (setv theta-pos 72)
  (setv frame-step 24)

  (setv (. bpy context scene frame-start) start)
  (setv (. bpy context scene frame-end) end)

  (for [i (range n)]
       ((. bpy ops mesh primitive-uv-sphere-add) :size size)
       (setv obj (. bpy context scene objects active))
       (setv mat ((. bpy data materials new) "Sphere"))
       (setv (. mat diffuse-color)
             (, 0
                0
                0))
       ((. obj data materials append) mat)
       (for [(, theta frame) (zip (range 0 (+ theta-max theta-step) theta-step)
                                  (range start (+ end frame-step) frame-step))]
            ;; set each key frames
            (setv span (- end start))
            ((. bpy context scene frame-set) frame)
             (setv (. obj location)
                   (, (* radius
                         ((. math cos) ((. math radians) (+ (* theta-pos i)
                                                            theta))))
                      (* radius
                         ((. math sin) ((. math radians) (+ (* theta-pos i)
                                                            theta))))
                      0))
            ((. obj keyframe-insert) :data-path "location")))
  0)


(when (= --name-- "__main__")
      ((. sys exit) (main)))
