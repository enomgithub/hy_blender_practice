#!/usr/bin/env hy
;; -*- coding: utf-8 -*-

(import math)
(import sys)

(import bpy)


(defn main []
  (setv size 5)
  (setv radius 50)
  (setv n 5)
  (setv theta-pos (/ 360 n))
  (setv theta-step (* 2 theta-pos))
  (setv frame-step 24)

  (setv (. bpy context scene frame-start) 0)
  (setv (. bpy context scene frame-end) (* n frame-step))

  (for [i (range n)]
       ((. bpy ops mesh primitive-uv-sphere-add) :size size)
       (setv obj (. bpy context scene objects active))
       (setv mat ((. bpy data materials new) "Sphere"))
       (setv (. mat diffuse-color) (, 0 0 0))
       ((. obj data materials append) mat)
       (for [j (range (inc n))]
            ((. bpy context scene frame-set) (* j frame-step))
            (setv (. obj location)
                  (, (* radius
                        ((. math cos)
                         ((. math radians) (-> i
                                               (* theta-pos)
                                               (+ (* j theta-step))))))
                     (* radius
                        ((. math sin)
                         ((. math radians) (-> i
                                               (* theta-pos)
                                               (+ (* j theta-step))))))
                     0))
            ((. obj keyframe-insert) :data-path "location")))
  0)


(when (= --name-- "__main__")
      ((. sys exit) (main)))
