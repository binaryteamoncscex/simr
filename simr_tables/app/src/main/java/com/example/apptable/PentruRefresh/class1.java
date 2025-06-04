package com.example.apptable.PentruRefresh;

import com.google.firebase.database.*;
import java.util.*;

public class class1 {
    private final DatabaseReference menuRef;
    private final DatabaseReference ingredientsRef;
    private final String userId;

    public class1(String userId) {
        this.userId = userId;
        FirebaseDatabase database = FirebaseDatabase.getInstance();
        this.menuRef = database.getReference("kitchen").child(userId).child("menu").child("list");
        this.ingredientsRef = database.getReference("kitchen").child(userId).child("ingredients").child("list");
    }

    public class1(DatabaseReference menuRef, DatabaseReference ingredientsRef, String userId) {
        this.menuRef = menuRef;
        this.ingredientsRef = ingredientsRef;
        this.userId = userId;
    }

    public void updateAllItemsAvailability() {
        ingredientsRef.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot ingredientsSnapshot) {
                Map<String, Double> availableIngredients = new HashMap<>();

                // Citim ingredientele disponibile
                for (DataSnapshot ingredient : ingredientsSnapshot.getChildren()) {
                    String name = ingredient.child("name").getValue(String.class);
                    Double quantity = ingredient.child("quantity").getValue(Double.class);
                    if (name != null && quantity != null) {
                        availableIngredients.put(name.trim(), quantity);
                    }
                }

                // Verificăm fiecare produs din meniu
                menuRef.addListenerForSingleValueEvent(new ValueEventListener() {
                    @Override
                    public void onDataChange(DataSnapshot menuSnapshot) {
                        for (DataSnapshot item : menuSnapshot.getChildren()) {
                            String ingredientsStr = item.child("ingredients").getValue(String.class);
                            String quantitiesStr = item.child("quantities").getValue(String.class);

                            boolean isAvailable = checkAvailability(ingredientsStr, quantitiesStr, availableIngredients);
                            item.getRef().child("menuAvailability").setValue(isAvailable);
                        }
                    }

                    @Override
                    public void onCancelled(DatabaseError error) {
                        System.err.println("Eroare la citirea meniului: " + error.getMessage());
                    }
                });
            }

            @Override
            public void onCancelled(DatabaseError error) {
                System.err.println("Eroare la citirea ingredientelor: " + error.getMessage());
            }
        });
    }

    private boolean checkAvailability(String ingredientsStr, String quantitiesStr, Map<String, Double> available) {
        if (ingredientsStr == null || quantitiesStr == null) return false;

        String[] ingredientNames = ingredientsStr.trim().split(" ");
        String[] quantityStrings = quantitiesStr.trim().split(" ");

        if (ingredientNames.length != quantityStrings.length) return false;

        for (int i = 0; i < ingredientNames.length; i++) {
            String name = ingredientNames[i].trim();
            double requiredQty;
            try {
                requiredQty = Double.parseDouble(quantityStrings[i]);
            } catch (NumberFormatException e) {
                return false;
            }

            if (available.getOrDefault(name, 0.0) < requiredQty) {
                return false;
            }
        }

        return true;
    }

    public void startAutoUpdates() {
        ingredientsRef.getParent().addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot snapshot) {
                updateAllItemsAvailability();
            }

            @Override
            public void onCancelled(DatabaseError error) {
                System.err.println("Monitorizare ingrediente eșuată: " + error.getMessage());
            }
        });
    }
}
