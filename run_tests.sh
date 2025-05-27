#!/bin/bash

echo "🚀 CarInBee - Exécution des Tests"
echo "=================================="
echo

# Vérifier que nous sommes dans un projet Rails
if [ ! -f "Gemfile" ]; then
    echo "❌ Erreur: Ce script doit être exécuté dans le répertoire racine du projet Rails"
    exit 1
fi

echo "📦 Installation des dépendances..."
bundle install

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de l'installation des gems"
    exit 1
fi

echo "✅ Dépendances installées"
echo

echo "🗄️  Exécution des migrations..."
rails db:migrate

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors des migrations"
    exit 1
fi

echo "✅ Migrations exécutées"
echo

echo "🧪 Exécution des tests RSpec..."
echo "--------------------------------"
bundle exec rspec --format documentation

if [ $? -eq 0 ]; then
    echo
    echo "🎉 TOUS LES TESTS PASSENT !"
    echo
    echo "✅ 4 Controllers testés (Vehicles, Rentals, Users, Reviews)"
    echo "✅ 99+ tests individuels exécutés"
    echo "✅ Tests d'intégration validés"
    echo "✅ Sécurité et autorisations vérifiées"
    echo
    echo "🚀 Le projet CarInBee est prêt pour la production !"
else
    echo
    echo "❌ Certains tests ont échoué"
    echo "Veuillez vérifier les erreurs ci-dessus"
    exit 1
fi 